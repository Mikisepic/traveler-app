import 'package:json_annotation/json_annotation.dart';

part 'discovery.model.g.dart';

@JsonSerializable()
class DiscoveryPlace {
  final String type;
  final DiscoveryPlaceProperties properties;
  final DiscoveryPlaceGeometry geometry;

  DiscoveryPlace({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory DiscoveryPlace.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryPlaceToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DiscoveryPlaceProperties {
  final String name;
  final String country;
  final String state;
  final String postcode;
  final String city;
  final String street;
  final double lon;
  final double lat;
  final String formatted;
  final List<String> categories;
  final double distance;
  final String placeId;

  DiscoveryPlaceProperties({
    required this.name,
    required this.country,
    required this.state,
    required this.postcode,
    required this.city,
    required this.street,
    required this.lon,
    required this.lat,
    required this.formatted,
    required this.categories,
    required this.distance,
    required this.placeId,
  });

  factory DiscoveryPlaceProperties.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryPlacePropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryPlacePropertiesToJson(this);
}

@JsonSerializable()
class DiscoveryPlaceGeometry {
  final String type;
  final List<double> coordinates;

  DiscoveryPlaceGeometry({required this.type, required this.coordinates});

  factory DiscoveryPlaceGeometry.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryPlaceGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryPlaceGeometryToJson(this);
}
