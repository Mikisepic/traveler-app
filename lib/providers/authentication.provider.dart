import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/firebase_options.dart';
import 'package:traveler/models/models.dart';

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  User? get user => FirebaseAuth.instance.currentUser;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addTrip(Trip trip) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    // CollectionReference markersCollection = FirebaseFirestore.instance.collection('markers');

    return FirebaseFirestore.instance.collection('markers').add({
      'id': trip.id,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'title': trip.title,
      'isPrivate': trip.isPrivate,
      // 'markers': markersCollection.doc()
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }
}
