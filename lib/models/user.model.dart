import 'package:cloud_firestore/cloud_firestore.dart';

import 'marker.model.dart';
import 'trip.model.dart';

class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String about;
  final List<Trip> trips;
  final List<Marker> markers;

  UserInfo({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    required this.email,
    this.about = '',
    this.trips = const [],
    this.markers = const [],
  });

  factory UserInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserInfo(
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
