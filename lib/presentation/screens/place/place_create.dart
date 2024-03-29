import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/providers/providers.dart';

class PlaceCreateScreen extends StatefulWidget {
  const PlaceCreateScreen({super.key});

  @override
  State<PlaceCreateScreen> createState() => _PlaceCreateScreenState();
}

class _PlaceCreateScreenState extends State<PlaceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  String mapboxId = '';
  double latitude = 0;
  double longitude = 0;

  @override
  Widget build(BuildContext context) {
    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: titleController,
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Search(
        initialValue: '',
        onSearchComplete: (mapboxMarker) {
          setState(() {
            mapboxId = mapboxMarker.mapboxId;
            latitude = mapboxMarker.coordinates.latitude;
            longitude = mapboxMarker.coordinates.longitude;
          });
        },
      ),
    );

    Widget submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final titleValue = titleController.text;

            context.read<PlaceProvider>().create(
                Place(
                  title: titleValue,
                  mapboxId: mapboxId,
                  latitude: latitude,
                  longitude: longitude,
                ),
                context.read<AuthenticationProvider>().isAuthenticated);

            context.goNamed('place_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
        label: 'Add New Place',
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: <Widget>[titleField, searchField, submitButton],
              )),
        ));
  }
}
