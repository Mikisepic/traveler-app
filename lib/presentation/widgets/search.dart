import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _suggestions = [];

  Future<List<String>> fetchSuggestions(String query) async {
    final response = await http
        .get((Uri.parse('https://jsonplaceholder.typicode.com/albums/1')));
    return response.statusCode == 200 ? ['Item 1', 'Item 2'] : [];
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
              List<String> suggestions = snapshot.data as List<String>;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      // Handle user selection from suggestions
                      _textEditingController.text = suggestions[index];
                      setState(() {
                        // Clear the suggestions
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
