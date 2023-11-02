import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/widgets/widgets.dart';

class NewPlaceScreen extends StatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  State<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends State<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
        label: 'New Place',
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Search(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          final titleValue = titleController.text;
                          final random = Random();
                          final randomLatitude = 40 + random.nextDouble() * 10;
                          final randomLongitude =
                              -90 + random.nextDouble() * 20;
                          context.read<MarkerProvider>().addMarker(
                                titleValue,
                                randomLatitude,
                                randomLongitude,
                              );
                          context.goNamed('place_list');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              )),
        ));
  }
}
