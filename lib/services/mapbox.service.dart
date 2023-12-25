import 'dart:convert';

import 'package:http/http.dart';
import 'package:traveler/constants/constants.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class MapboxService {
  final String suggestURI =
      'https://api.mapbox.com/search/searchbox/v1/suggest';
  final String retrieveURI =
      'https://api.mapbox.com/search/searchbox/v1/retrieve';
  final String optimizationURI =
      'https://api.mapbox.com/optimized-trips/v1/mapbox';
  final String sessionToken = const Uuid().v4();

  Future<List<MarkerSuggestion>> fetchSuggestions(String query) async {
    final url = Uri.parse(
        '$suggestURI?q=$query&access_token=${ApplicationConstants.mapboxAccessToken}&session_token=$sessionToken');
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
        '$retrieveURI/$id?access_token=${ApplicationConstants.mapboxAccessToken}&session_token=$sessionToken');
    final Response response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['features'] as List<dynamic>;

      return MarkerRetrieval.fromJson(
          data[0]['properties'] as Map<String, dynamic>);
    }

    throw Exception(response.reasonPhrase);
  }

  Future<TripOptimization> fetchTripOptimization(
      String profile, List<MarkerCoordinates> coordinates) async {
    final url = Uri.parse(
        "$optimizationURI/$profile/${coordinates.map((e) => '${e.longitude},${e.latitude}').toList().join(';')}?steps=true&geometries=geojson&access_token=${ApplicationConstants.mapboxAccessToken}");
    final Response response = await get(url);
    print(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TripOptimization.fromJson(data as Map<String, dynamic>);
    }
    throw Exception(response.reasonPhrase);
  }
}
