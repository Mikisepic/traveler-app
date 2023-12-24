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

  StreamSubscription<QuerySnapshot>? _notesSubscription;
  bool _loading = false;
  bool get loading => _loading;
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NoteProvider() {
    init();
  }

  init() async {
    firebaseAuth.userChanges().listen((user) {
      _notesSubscription?.cancel();

      if (user != null) {
        _notesSubscription = firebaseFirestore
            .collection('notes')
            .snapshots()
            .listen((snapshot) {
          _notes = [];
          _loading = true;
          for (final document in snapshot.docs) {
            _notes.add(
              Note(
                id: document.id,
                content: document.data()['content'] as String,
                markerId: document.data()['markerId'] as DocumentReference,
              ),
            );
          }
          _loading = false;
          notifyListeners();
        });
      } else {
        _notes = [];
      }
      notifyListeners();
    });
  }

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
    List<Note> notes = await getNotes();

    for (Note note in notes) {
      Marker associatedMarker =
          await MarkerProvider().getMarkerByReference(note.markerId);
      print(
          'Note ${note.id} is associated with Marker ${associatedMarker.title}');
    }
  }
}
