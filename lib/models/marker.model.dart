class Marker {
  final String id;
  final String mapboxId;
  final String title;
  final double latitude;
  final double longitude;

  Marker({
    required this.id,
    required this.mapboxId,
    required this.title,
    required this.latitude,
    required this.longitude,
  });
}

class MapboxMarker {
  final String mapboxId;
  final String name;
  final double latitude;
  final double longitude;

  MapboxMarker({
    required this.mapboxId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory MapboxMarker.fromJson(Map<String, dynamic> json) {
    return MapboxMarker(
        mapboxId: json['properties']['mapbox_id'] as String,
        name: json['properties']['name'] as String,
        latitude: json['properties']['coordinates']['latitude'] as double,
        longitude: json['properties']['coordinates']['longitude'] as double);
  }
}

class MarkerSuggestion {
  final String mapboxId;
  final String name;

  MarkerSuggestion({required this.mapboxId, required this.name});

  factory MarkerSuggestion.fromJson(Map<String, dynamic> json) {
    return MarkerSuggestion(
        mapboxId: json['mapbox_id'] as String, name: json['name'] as String);
  }
}
