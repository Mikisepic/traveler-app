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
    final Response response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['suggestions'] as List<dynamic>;

      return data
          .map(
              (json) => MarkerSuggestion.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception(response.reasonPhrase);
  }

  Future<MarkerRetrieval> retrieveSuggestionDetails(String id) async {
    final url = Uri.parse(
        '$retrieveURI/$id?access_token=$mapboxAccessToken&session_token=$sessionToken');
    final Response response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['features'] as List<dynamic>;

      return MarkerRetrieval.fromJson(
          data[0]['properties'] as Map<String, dynamic>);
    }

    throw Exception(response.reasonPhrase);
  }
}
