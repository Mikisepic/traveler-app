import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/note.model.dart';

class NoteProvider with ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final bool _loading = false;
  bool get loading => _loading;
  final List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<List<Note>> getNotes(String tripId, String userId) async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('updated_at', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => Note(
              id: doc.id,
              content: doc['content'] as String,
              userId: doc['userId'] as String,
            ))
        .toList();
  }

  Future<Note?> getNoteByReference(DocumentReference noteRef) async {
    final snapshot = await noteRef
        .withConverter<Note>(
            fromFirestore: Note.fromFirestore,
            toFirestore: (Note note, _) => note.toFirestore())
        .get();

    return snapshot.data()!;
  }
}
