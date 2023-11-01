import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:traveler/models/models.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Marker> _suggestions = [];

  Future<List<Marker>> fetchSuggestions(String query) async {
    final response = await http
        .get((Uri.parse('https://jsonplaceholder.typicode.com/albums/')));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Marker> markers =
          body.map((dynamic item) => Marker.fromJson(item)).toList();

      return markers;
    }

    throw "Unable to retrieve posts.";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _textEditingController,
          onChanged: (query) async {
            _suggestions = await fetchSuggestions(query);
          },
        ),
        FutureBuilder(
          future: fetchSuggestions(_textEditingController.text),
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
