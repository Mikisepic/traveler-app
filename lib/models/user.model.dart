import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileMetadata {
  final String id;
  final String displayName;
  final String email;
  final List<DocumentReference> markers;
  final List<DocumentReference> trips;

  UserProfileMetadata({
    required this.id,
    required this.displayName,
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
      displayName: data?['displayName'] as String,
      email: data?['email'] as String,
      markers: (data?['markers'] as List<dynamic>)
          .map((e) => FirebaseFirestore.instance.doc(e.toString()))
          .toList(),
      trips: (data?['trips'] as List<dynamic>)
          .map((e) => FirebaseFirestore.instance.doc(e.toString()))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "userId": id,
      "email": email,
      "displayName": displayName,
      "markers": markers,
      "trips": trips,
    };
  }
}
