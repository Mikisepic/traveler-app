import 'dart:convert';

import 'package:http/http.dart';
import 'package:traveler/common/common.dart';
import 'package:traveler/models/models.dart';

class GeoapifyService {
  final String placesURI = 'https://api.geoapify.com/v2/places';

  Future<List<DiscoveryPlace>> fetchPlaceSuggestions(double lat, double lng,
      List<String> categories, List<String> conditions) async {
    final url = Uri.parse(
        "$placesURI?bias=proximity:$lng,$lat&categories=${categories.join(',')}${conditions.isNotEmpty ? '&conditions=${conditions.join(',')}' : ''}&limit=20&apiKey=$geoapifyApiKey");
    final Response response = await get(url);
    print(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['features'] as List<dynamic>;
      return data
          .map((json) => DiscoveryPlace.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception(response.reasonPhrase);
  }
}
