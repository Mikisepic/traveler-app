class MapboxMarkerSuggestion {
  final List<dynamic> suggestions;

  MapboxMarkerSuggestion({required this.suggestions});

  factory MapboxMarkerSuggestion.fromJson(Map<String, dynamic> json) {
    return MapboxMarkerSuggestion(
        suggestions: json['suggestions'] as List<dynamic>);
  }
}

class MapboxMarkerFeatures {
  final List<dynamic> features;

  MapboxMarkerFeatures({required this.features});

  factory MapboxMarkerFeatures.fromJson(Map<String, dynamic> json) {
    return MapboxMarkerFeatures(features: json['features'] as List<dynamic>);
  }
}
