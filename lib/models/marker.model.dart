class Marker {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  Marker({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
        id: json['id'] as String,
        title: json['name'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double);
  }
}

class MarkerSuggestion {
  final String id;
  final String name;

  MarkerSuggestion({required this.id, required this.name});

  factory MarkerSuggestion.fromJson(Map<String, dynamic> json) {
    return MarkerSuggestion(
        id: json['mapbox_id'] as String, name: json['name'] as String);
  }
}

class MapboxMarkerSuggestion {
  final List<dynamic> suggestions;

  MapboxMarkerSuggestion({required this.suggestions});

  factory MapboxMarkerSuggestion.fromJson(Map<String, dynamic> json) {
    return MapboxMarkerSuggestion(
        suggestions: json['suggestions'] as List<dynamic>);
  }
}
