// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkerCoordinates _$MarkerCoordinatesFromJson(Map<String, dynamic> json) =>
    MarkerCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$MarkerCoordinatesToJson(MarkerCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

MarkerRetrieval _$MarkerRetrievalFromJson(Map<String, dynamic> json) =>
    MarkerRetrieval(
      mapboxId: json['mapbox_id'] as String,
      name: json['name'] as String,
      coordinates: MarkerCoordinates.fromJson(
          json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MarkerRetrievalToJson(MarkerRetrieval instance) =>
    <String, dynamic>{
      'mapbox_id': instance.mapboxId,
      'name': instance.name,
      'coordinates': instance.coordinates,
    };

MarkerSuggestion _$MarkerSuggestionFromJson(Map<String, dynamic> json) =>
    MarkerSuggestion(
      mapboxId: json['mapbox_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MarkerSuggestionToJson(MarkerSuggestion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mapbox_id': instance.mapboxId,
    };
