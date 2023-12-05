import 'package:json_annotation/json_annotation.dart';

part 'marker.model.g.dart';

class Marker {
  final String id;
  final String mapboxId;
  final String title;
  final double latitude;
  final double longitude;
  final bool isFavorite;

  Marker({
    this.id = '',
    required this.mapboxId,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MarkerRetrieval {
  final String mapboxId;
  final String name;
  final MarkerCoordinates coordinates;

  MarkerRetrieval({
    required this.mapboxId,
    required this.name,
    required this.coordinates,
  });

  factory MarkerRetrieval.fromJson(Map<String, dynamic> json) =>
      _$MarkerRetrievalFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerRetrievalToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MarkerSuggestion {
  final String name;
  final String mapboxId;

  MarkerSuggestion({required this.mapboxId, required this.name});

  factory MarkerSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MarkerSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerSuggestionToJson(this);
}

@JsonSerializable()
class MarkerCoordinates {
  final double latitude;
  final double longitude;

  MarkerCoordinates({required this.latitude, required this.longitude});

  factory MarkerCoordinates.fromJson(Map<String, dynamic> json) =>
      _$MarkerCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerCoordinatesToJson(this);
}
