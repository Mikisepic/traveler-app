import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/marker.model.dart';
import 'package:traveler/models/note.model.dart';
import 'package:traveler/providers/marker.provider.dart';

class NoteProvider with ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  Future<List<Note>> getNotes() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('notes').get();
    return querySnapshot.docs
        .map((doc) => Note(
              id: doc.id,
              content: doc['content'] as String,
              markerId: doc['markerId'] as DocumentReference,
            ))
        .toList();
  }

  Future<void> displayNotesWithMarkers() async {
    _loading = true;
    List<Note> notes = await getNotes();

    for (Note note in notes) {
      Marker associatedMarker =
          await MarkerProvider().getMarkerByReference(note.markerId);

      print(
          'Note ${note.id} is associated with Marker ${associatedMarker.title}');
    }
    _notes = notes;
    _loading = false;
    notifyListeners();
  }
}
