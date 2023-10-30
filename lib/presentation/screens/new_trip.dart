import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
        label: 'New Trip',
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: PlaceDropwdown(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          final titleValue = titleController.text;
                          final descriptionValue = descriptionController.text;
                          context.read<TripProvider>().addTrip(Trip(
                              id: const Uuid().v4(),
                              title: titleValue,
                              description: descriptionValue,
                              markers: []));
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
