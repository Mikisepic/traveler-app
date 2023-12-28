import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  final String id;
  final String content;
  final DateTime setUntil;
  final String userId;

  Reminder({
    required this.id,
    required this.content,
    required this.setUntil,
    required this.userId,
  });

  factory Reminder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Reminder(
      id: snapshot.id,
      content: data?['content'] as String,
      setUntil: (data?['setUntil'] as Timestamp).toDate(),
      userId: data?['userId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "content": content,
      "setUntil": setUntil,
      "userId": userId,
    };
  }
}
