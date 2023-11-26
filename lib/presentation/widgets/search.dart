import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/services/services.dart';

class Search extends StatefulWidget {
  final Function(double lat, double lng) onSearchComplete;

  const Search({super.key, required this.onSearchComplete});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  final MarkerService markerService = MarkerService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TypeAheadField<MarkerSuggestion>(
          suggestionsCallback: (search) async {
            return await markerService.fetchSuggestions(search);
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
            Future<Marker> marker =
                markerService.retrieveSuggestionDetails(value.id);
            marker.then((value) =>
                widget.onSearchComplete(value.latitude, value.longitude));
          },
        )
      ],
    );
  }
}
