import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class ReminderProvider with ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final List<Reminder> _reminders = [];
  List<Reminder> get notes => _reminders;

  final bool _loading = false;
  bool get loading => _loading;

  Future<List<Reminder>> getRemindersByUser(String userId) async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('reminders')
        .where('userId', isEqualTo: userId)
        .orderBy('updated_at', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => Reminder(
              id: doc.id,
              content: doc['content'] as String,
              setUntil: (doc['setUntil'] as Timestamp).toDate(),
              userId: doc['userId'] as String,
            ))
        .toList();
  }

  Future<Reminder> getReminderByReference(DocumentReference reminderRef) async {
    final snapshot = await reminderRef
        .withConverter<Reminder>(
            fromFirestore: Reminder.fromFirestore,
            toFirestore: (Reminder reminder, _) => reminder.toFirestore())
        .get();

    return snapshot.data()!;
  }
}
