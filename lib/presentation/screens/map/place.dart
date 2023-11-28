import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class Place extends StatefulWidget {
  final Marker marker;
  final Function(Marker updatedMarker) onEditComplete;

  const Place({super.key, required this.marker, required this.onEditComplete});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  final _formKey = GlobalKey<FormState>();
  late var titleController = TextEditingController(text: widget.marker.title);
  late String mapboxId = widget.marker.mapboxId;
  late double latitude = widget.marker.latitude;
  late double longitude = widget.marker.longitude;
  late bool isFavorite = widget.marker.isFavorite;

  @override
  Widget build(BuildContext context) {
    Widget titleField = Container(
      padding: const EdgeInsets.all(10),
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
            icon: (isFavorite
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
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

    Widget submitButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final titleValue = titleController.text;
              widget.onEditComplete(Marker(
                  id: widget.marker.id,
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
          children: <Widget>[titleField, submitButton]),
    );
  }
}
