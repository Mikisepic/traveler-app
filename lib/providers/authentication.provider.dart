import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  AuthenticationProvider(
      {required this.firebaseAuth, required this.firebaseFirestore}) {
    init();
  }

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => firebaseAuth.currentUser;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    firebaseAuth.userChanges().listen((user) {
      if (user != null) {
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }

  void registerUserInFirestore(
      String uid, String? email, String? displayName) async {
    await firebaseFirestore.collection('users').doc(uid).set({
      'userId': uid,
      'email': email,
      'displayName': displayName,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void deleteUserFromFirestore() async {
    if (user != null) {
      await firebaseFirestore.collection('users').doc(user!.uid).delete();
    }
  }
}
