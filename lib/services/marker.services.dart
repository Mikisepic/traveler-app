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
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;

      MapboxMarkerSuggestion maboxMarkerSuggestions =
          MapboxMarkerSuggestion.fromJson(body);

      List<MarkerSuggestion> markerSuggestions = maboxMarkerSuggestions
          .suggestions
          .map(
              (item) => MarkerSuggestion.fromJson(item as Map<String, dynamic>))
          .toList();

      return markerSuggestions;
    }

    throw "Unable to retrieve suggestions";
  }

  Future<Marker> retrieveSuggestionDetails(String id) async {
    final url = Uri.parse(
        '$retrieveURI/$id?access_token=$mapboxAccessToken&session_token=$sessionToken');
    final Response response = await get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;

      MapboxMarkerFeatures mapboxMarkerFeatures =
          MapboxMarkerFeatures.fromJson(body);

      Marker marker = Marker.fromJson(
          mapboxMarkerFeatures.features[0] as Map<String, dynamic>);

      return marker;
    }

    throw "Unable to retrieve place";
  }
}
