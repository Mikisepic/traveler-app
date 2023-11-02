import 'dart:convert';

import 'package:http/http.dart';
import 'package:traveler/common/common.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class MarkerService {
  final String suggestURI =
      'https://api.mapbox.com/search/searchbox/v1/suggest';
  final String retrieveURI =
      'https://api.mapbox.com/search/searchbox/v1/retrieve';
  final String sessionToken = const Uuid().v4();

  Future<List<MarkerSuggestion>> fetchSuggestions(String query) async {
    final url = Uri.parse(
        '$suggestURI?q=$query&access_token=$mapboxAccessToken&session_token=$sessionToken');
    final response = await get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      MapboxMarkerSuggestion maboxMarkerSuggestions =
          MapboxMarkerSuggestion.fromJson(body);

      List<MarkerSuggestion> markerSuggestions = maboxMarkerSuggestions
          .suggestions
          .map((item) => MarkerSuggestion.fromJson(item))
          .toList();

      return markerSuggestions;
    }

    throw "Unable to retrieve posts.";
  }
}
