import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/user.model.dart';

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

  List<UserProfileMetadata> _users = [];
  List<UserProfileMetadata> get users => _users;
  UserProfileMetadata? _userMetadata;
  UserProfileMetadata? get userMetadata => _userMetadata;
  StreamSubscription<QuerySnapshot>? _usersSubscription;

  init() {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    firebaseAuth.userChanges().listen((user) {
      _usersSubscription?.cancel();
      _isAuthenticated = user != null;
      notifyListeners();

      if (isAuthenticated) {
        _usersSubscription = FirebaseFirestore.instance
            .collection('users')
            .orderBy('updated_at', descending: true)
            .snapshots()
            .listen((snapshot) {
          _users = [];
          for (final document in snapshot.docs) {
            _users.add(UserProfileMetadata(
              id: document.id,
              displayName: document.data()['displayName'] as String,
              email: document.data()['email'] as String,
            ));
          }
          notifyListeners();

          _userMetadata =
              _users.firstWhere((element) => element.id == user!.uid);
          notifyListeners();
        });
        updateUserDetails();
      } else {
        _users = [];
        _userMetadata = null;
        notifyListeners();
      }
    });
  }

  void registerUserInFirestore(String uid, String? email, String? displayName) {
    firebaseFirestore.collection('users').doc(uid).set({
      'userId': uid,
      'email': email,
      'displayName': displayName,
      'markers': [],
      'trips': [],
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void updateUserDetails() {
    firebaseFirestore.collection('users').doc(user!.uid).update({
      'email': user!.email,
      'displayName': user!.displayName,
    });
  }
}
