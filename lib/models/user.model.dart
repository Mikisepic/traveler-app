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
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.about,
    required this.trips,
    required this.markers,
  });

  factory UserInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserInfo(
      id: data?['id'] as String,
      firstName: data?['firstName'] as String,
      lastName: data?['lastName'] as String,
      email: data?['email'] as String,
      about: data?['about'] as String,
      trips: data?['trips'] as List<Trip>,
      markers: data?['markers'] as List<Marker>,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "about": about,
      "trips": trips,
      "markers": markers,
    };
  }
}
