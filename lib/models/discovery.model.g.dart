// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoveryPlace _$DiscoveryPlaceFromJson(Map<String, dynamic> json) =>
    DiscoveryPlace(
      type: json['type'] as String,
      properties: DiscoveryPlaceProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      geometry: DiscoveryPlaceGeometry.fromJson(
          json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DiscoveryPlaceToJson(DiscoveryPlace instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

DiscoveryPlaceProperties _$DiscoveryPlacePropertiesFromJson(
        Map<String, dynamic> json) =>
    DiscoveryPlaceProperties(
      name: json['name'] as String,
      country: json['country'] as String,
      state: json['state'] as String,
      county: json['county'] as String,
      city: json['city'] as String,
      lon: (json['lon'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      details:
          (json['details'] as List<dynamic>).map((e) => e as String).toList(),
      distance: (json['distance'] as num).toDouble(),
      placeId: json['place_id'] as String,
    );

Map<String, dynamic> _$DiscoveryPlacePropertiesToJson(
        DiscoveryPlaceProperties instance) =>
    <String, dynamic>{
      'name': instance.name,
      'country': instance.country,
      'state': instance.state,
      'county': instance.county,
      'city': instance.city,
      'lon': instance.lon,
      'lat': instance.lat,
      'categories': instance.categories,
      'details': instance.details,
      'distance': instance.distance,
      'place_id': instance.placeId,
    };

DiscoveryPlaceGeometry _$DiscoveryPlaceGeometryFromJson(
        Map<String, dynamic> json) =>
    DiscoveryPlaceGeometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$DiscoveryPlaceGeometryToJson(
        DiscoveryPlaceGeometry instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
