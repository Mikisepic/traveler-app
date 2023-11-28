import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/presentation/widgets/widgets.dart';
import 'package:traveler/providers/providers.dart';

class NewPlaceScreen extends StatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  State<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends State<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  String mapboxId = '';
  double latitude = 0;
  double longitude = 0;

  @override
  Widget build(BuildContext context) {
    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
    );

    Widget searchField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Search(
        onSearchComplete: (mapboxMarker) {
          setState(() {
            mapboxId = mapboxMarker.mapboxId;
            latitude = mapboxMarker.latitude;
            longitude = mapboxMarker.longitude;
          });
        },
      ),
    );

    Widget searchFieldPayload = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Text('$latitude, $longitude'),
    );

    Widget submitButton = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final titleValue = titleController.text;
            context.read<MarkerProvider>().addMarker(
                  titleValue,
                  mapboxId,
                  latitude,
                  longitude,
                );
            context.goNamed('place_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
        label: 'New Place',
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleField,
                  searchField,
                  searchFieldPayload,
                  submitButton
                ],
              )),
        ));
  }
}
