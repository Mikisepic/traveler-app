import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip.model.g.dart';

class Trip {
  final String id;
  final String title;
  final String description;
  final bool isPrivate;
  final List<DocumentReference> markers;
  final List<DocumentReference> contributors;
  final List<DocumentReference> notes;

  Trip({
    this.id = '',
    required this.title,
    this.description = '',
    this.isPrivate = false,
    this.markers = const [],
    this.contributors = const [],
    this.notes = const [],
  });

  factory Trip.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Trip(
      id: snapshot.id,
      title: data?['title'] as String,
      description: data?['description'] as String,
      isPrivate: data?['isPrivate'] as bool,
      markers: (data?['markers'] as List<dynamic>)
          .map((e) => FirebaseFirestore.instance.doc(e.toString()))
          .toList(),
      contributors: (data?['contributors'] as List<dynamic>)
          .map((e) => FirebaseFirestore.instance.doc(e.toString()))
          .toList(),
      // notes: (data?['notes'] as List<dynamic>)
      //     .map((e) => FirebaseFirestore.instance.doc(e.toString()))
      //     .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "notes": notes,
      "isPrivate": isPrivate,
      "markers": markers,
      "contributors": contributors,
    };
  }
}

@JsonSerializable()
class TripOptimization {
  final String code;
  final List<OptimizationWaypoint> waypoints;
  final List<OptimizationTrip> trips;

  TripOptimization(
      {required this.code, required this.waypoints, required this.trips});

  factory TripOptimization.fromJson(Map<String, dynamic> json) =>
      _$TripOptimizationFromJson(json);

  Map<String, dynamic> toJson() => _$TripOptimizationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OptimizationWaypoint {
  final double distance;
  final String name;
  final List<double> location; // [longitude, latitude]
  final int waypointIndex;
  final int tripsIndex;

  OptimizationWaypoint(
      {required this.distance,
      required this.name,
      required this.location,
      required this.tripsIndex,
      required this.waypointIndex});

  factory OptimizationWaypoint.fromJson(Map<String, dynamic> json) =>
      _$OptimizationWaypointFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationWaypointToJson(this);
}

@JsonSerializable()
class OptimizationTrip {
  final OptimizationGeometry geometry;
  final List<OptimizationTripLeg> legs;
  final double duration;
  final double distance;

  OptimizationTrip(
      {required this.geometry,
      required this.legs,
      required this.duration,
      required this.distance});

  factory OptimizationTrip.fromJson(Map<String, dynamic> json) =>
      _$OptimizationTripFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationTripToJson(this);
}

@JsonSerializable()
class OptimizationGeometry {
  final List<List<double>> coordinates;
  final String type;

  OptimizationGeometry({required this.coordinates, required this.type});

  factory OptimizationGeometry.fromJson(Map<String, dynamic> json) =>
      _$OptimizationGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationGeometryToJson(this);
}

@JsonSerializable()
class OptimizationTripLeg {
  final List<OptimizationTripLegStep> steps;
  final String summary;
  final double duration;
  final double distance;

  OptimizationTripLeg({
    required this.steps,
    required this.summary,
    required this.duration,
    required this.distance,
  });

  factory OptimizationTripLeg.fromJson(Map<String, dynamic> json) =>
      _$OptimizationTripLegFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationTripLegToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OptimizationTripLegStep {
  final OptimizationGeometry geometry;
  final OptimizationTripLegManeuver maneuver;
  final String mode;
  final String drivingSide;
  final String name;
  final double duration;
  final double distance;

  OptimizationTripLegStep({
    required this.geometry,
    required this.maneuver,
    required this.mode,
    required this.drivingSide,
    required this.name,
    required this.duration,
    required this.distance,
  });

  factory OptimizationTripLegStep.fromJson(Map<String, dynamic> json) =>
      _$OptimizationTripLegStepFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationTripLegStepToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OptimizationTripLegManeuver {
  final List<double> location;
  final String instruction;

  OptimizationTripLegManeuver(
      {required this.location, required this.instruction});

  factory OptimizationTripLegManeuver.fromJson(Map<String, dynamic> json) =>
      _$OptimizationTripLegManeuverFromJson(json);

  Map<String, dynamic> toJson() => _$OptimizationTripLegManeuverToJson(this);
}
