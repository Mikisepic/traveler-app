import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/note.model.dart';

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
              tripId: doc['tripId'] as DocumentReference,
            ))
        .toList();
  }

  Future<void> displayNotes() async {
    _loading = true;
    List<Note> noteList = await getNotes();
    _notes = noteList;
    _loading = false;
    notifyListeners();
  }
}
