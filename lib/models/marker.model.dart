import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marker.model.g.dart';

class Place {
  final String id;
  final String mapboxId;
  final String title;
  final double latitude;
  final double longitude;
  final int rating;
  final bool isFavorite;

  Place({
    this.id = '',
    required this.mapboxId,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.rating = 0,
    this.isFavorite = false,
  });

  factory Place.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Place(
      id: snapshot.id,
      mapboxId: data?['mapboxId'] as String,
      title: data?['title'] as String,
      latitude: (data?['coordinates'] as GeoPoint).latitude,
      longitude: (data?['coordinates'] as GeoPoint).longitude,
      rating: 0,
      isFavorite: data?['isFavorite'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "mapboxId": mapboxId,
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
      "rating": rating,
      "isFavorite": isFavorite,
    };
  }
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
