// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripOptimization _$TripOptimizationFromJson(Map<String, dynamic> json) =>
    TripOptimization(
      code: json['code'] as String,
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => OptimizationWaypoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      trips: (json['trips'] as List<dynamic>)
          .map((e) => OptimizationTrip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TripOptimizationToJson(TripOptimization instance) =>
    <String, dynamic>{
      'code': instance.code,
      'waypoints': instance.waypoints,
      'trips': instance.trips,
    };

OptimizationWaypoint _$OptimizationWaypointFromJson(
        Map<String, dynamic> json) =>
    OptimizationWaypoint(
      distance: (json['distance'] as num).toDouble(),
      name: json['name'] as String,
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      tripsIndex: json['trips_index'] as int,
      waypointIndex: json['waypoint_index'] as int,
    );

Map<String, dynamic> _$OptimizationWaypointToJson(
        OptimizationWaypoint instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'name': instance.name,
      'location': instance.location,
      'waypoint_index': instance.waypointIndex,
      'trips_index': instance.tripsIndex,
    };

OptimizationTrip _$OptimizationTripFromJson(Map<String, dynamic> json) =>
    OptimizationTrip(
      name: json['name'] as String,
      geometry: OptimizationGeometry.fromJson(
          json['geometry'] as Map<String, dynamic>),
      legs: (json['legs'] as List<dynamic>)
          .map((e) => OptimizationTripLeg.fromJson(e as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] as int,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$OptimizationTripToJson(OptimizationTrip instance) =>
    <String, dynamic>{
      'name': instance.name,
      'geometry': instance.geometry,
      'legs': instance.legs,
      'duration': instance.duration,
      'distance': instance.distance,
    };

OptimizationGeometry _$OptimizationGeometryFromJson(
        Map<String, dynamic> json) =>
    OptimizationGeometry(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$OptimizationGeometryToJson(
        OptimizationGeometry instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };

OptimizationTripLeg _$OptimizationTripLegFromJson(Map<String, dynamic> json) =>
    OptimizationTripLeg(
      steps: (json['steps'] as List<dynamic>)
          .map((e) =>
              OptimizationTripLegStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$OptimizationTripLegToJson(
        OptimizationTripLeg instance) =>
    <String, dynamic>{
      'steps': instance.steps,
      'summary': instance.summary,
      'duration': instance.duration,
      'distance': instance.distance,
    };

OptimizationTripLegStep _$OptimizationTripLegStepFromJson(
        Map<String, dynamic> json) =>
    OptimizationTripLegStep(
      geometry: (json['geometry'] as List<dynamic>)
          .map((e) => OptimizationGeometry.fromJson(e as Map<String, dynamic>))
          .toList(),
      maneuver: (json['maneuver'] as List<dynamic>)
          .map((e) =>
              OptimizationTripLegManeuver.fromJson(e as Map<String, dynamic>))
          .toList(),
      mode: json['mode'] as String,
      drivingSide: json['driving_side'] as String,
      name: json['name'] as String,
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$OptimizationTripLegStepToJson(
        OptimizationTripLegStep instance) =>
    <String, dynamic>{
      'geometry': instance.geometry,
      'maneuver': instance.maneuver,
      'mode': instance.mode,
      'driving_side': instance.drivingSide,
      'name': instance.name,
      'duration': instance.duration,
      'distance': instance.distance,
    };

OptimizationTripLegManeuver _$OptimizationTripLegManeuverFromJson(
        Map<String, dynamic> json) =>
    OptimizationTripLegManeuver(
      location: (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      instruction: json['instruction'] as String,
    );

Map<String, dynamic> _$OptimizationTripLegManeuverToJson(
        OptimizationTripLegManeuver instance) =>
    <String, dynamic>{
      'location': instance.location,
      'instruction': instance.instruction,
    };
