import 'dart:convert';

import 'package:http/http.dart';
import 'package:traveler/models/models.dart';

class MarkerService {
  final String uri = 'https://jsonplaceholder.typicode.com/albums/';

  Future<List<Marker>> fetchSuggestions(String query) async {
    final response = await get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Marker> markers =
          body.map((dynamic item) => Marker.fromJson(item)).toList();

      return markers;
    }

    throw "Unable to retrieve posts.";
  }
}
