import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/compoennts.dart';
import 'package:traveler/providers/providers.dart';
import 'package:uuid/uuid.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 20),
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

    Widget searchFieldPayload = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text('$latitude, $longitude'),
    );

    Widget submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final titleValue = titleController.text;

            context.read<MarkerProvider>().create(
                Marker(
                  id: const Uuid().v4(),
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
        label: 'New Place',
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
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
