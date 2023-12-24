import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String content;
  final DocumentReference markerId;

  Note({
    required this.id,
    required this.content,
    required this.markerId,
  });
}
