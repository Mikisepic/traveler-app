import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/providers/providers.dart';

class Place extends StatefulWidget {
  final String id;
  final Function(Marker updatedMarker) onEditComplete;

  const Place({super.key, required this.id, required this.onEditComplete});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final marker = context.read<MarkerProvider>().fetchOne(widget.id);
    late var titleController = TextEditingController(text: marker.title);
    late String mapboxId = marker.mapboxId;
    late double latitude = marker.latitude;
    late double longitude = marker.longitude;
    late bool isFavorite = marker.isFavorite;

    Widget titleField = Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
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
          )),
          IconButton(
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            color: Colors.red[500],
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
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
              widget.onEditComplete(Marker(
                  id: marker.id,
                  mapboxId: mapboxId,
                  title: titleValue,
                  latitude: latitude,
                  longitude: longitude,
                  isFavorite: isFavorite));
            }
          },
          child: const Text('Submit'),
        ));

    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            titleField,
            searchField,
            searchFieldPayload,
            submitButton
          ]),
    );
  }
}
