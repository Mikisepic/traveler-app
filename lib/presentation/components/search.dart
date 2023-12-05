import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/services/services.dart';

class Search extends StatefulWidget {
  final Function(MarkerRetrieval mapboxMarker) onSearchComplete;
  final String initialValue;

  const Search(
      {super.key, required this.onSearchComplete, required this.initialValue});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final MapboxService mapboxService = MapboxService();
  late final _textEditingController =
      TextEditingController(text: widget.initialValue);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TypeAheadField<MarkerSuggestion>(
          suggestionsCallback: (search) async {
            return await mapboxService.fetchSuggestions(search);
          },
          controller: _textEditingController,
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Search',
                ));
          },
          itemBuilder: (context, item) {
            return ListTile(
              title: Text(item.name),
            );
          },
          onSelected: (MarkerSuggestion value) {
            _textEditingController.text = value.name;
            Future<MarkerRetrieval> marker =
                mapboxService.retrieveSuggestionDetails(value.mapboxId);

            Future<TripOptimization> tripOptimization =
                mapboxService.fetchTripOptimization('driving', [
              MarkerCoordinates(latitude: 37.78, longitude: -122.42),
              MarkerCoordinates(latitude: 37.91, longitude: -122.45),
              MarkerCoordinates(latitude: 37.73, longitude: -122.48),
            ]);

            marker.then((value) => widget.onSearchComplete(value));
            tripOptimization.then((value) => print(value.toJson()));
          },
        )
      ],
    );
  }
}
