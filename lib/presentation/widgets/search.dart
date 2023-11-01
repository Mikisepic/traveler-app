import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/services/services.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Marker> _suggestions = [];
  final MarkerService markerService = MarkerService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _textEditingController,
          onChanged: (query) async {
            _suggestions = await markerService
                .fetchSuggestions(_textEditingController.text);
          },
        ),
        FutureBuilder(
          future: markerService.fetchSuggestions(_textEditingController.text),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              _suggestions = snapshot.data as List<Marker>;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index].title),
                    onTap: () {
                      _textEditingController.text = _suggestions[index].title;
                      setState(() {
                        _suggestions.clear();
                      });
                    },
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
