import 'package:cloud_firestore/cloud_firestore.dart';

import 'marker.model.dart';
import 'trip.model.dart';

class UserProfileMetadata {
  final String id;
  final String displayName;
  final String email;
  final List<Trip> trips;
  final List<Marker> markers;

  UserProfileMetadata({
    required this.id,
    this.displayName = '',
    required this.email,
    this.trips = const [],
    this.markers = const [],
  });

  factory UserProfileMetadata.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserProfileMetadata(
      id: data?['userId'] as String,
      email: data?['email'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": id,
      "email": email,
    };
  }
}
