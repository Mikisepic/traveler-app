import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';

class PlaceDropwdown extends StatefulWidget {
  const PlaceDropwdown({super.key});

  @override
  State<PlaceDropwdown> createState() => _PlaceDropwdownState();
}

class _PlaceDropwdownState extends State<PlaceDropwdown> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: context.read<MarkerProvider>().markers.first.title,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: context
          .read<MarkerProvider>()
          .markers
          .map<DropdownMenuEntry<String>>((Marker marker) {
        return DropdownMenuEntry<String>(value: marker.id, label: marker.title);
      }).toList(),
    );
  }
}
