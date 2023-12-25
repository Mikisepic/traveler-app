import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String content;
  final DocumentReference tripId;
  final String userId;

  Note({
    required this.id,
    required this.content,
    required this.tripId,
    required this.userId,
  });

  factory Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Note(
      id: snapshot.id,
      content: data?['content'] as String,
      tripId: FirebaseFirestore.instance.doc((data?['tripId'] as String)),
      userId: data?['userId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "content": content,
      "tripId": tripId,
      "userId": userId,
    };
  }
}
