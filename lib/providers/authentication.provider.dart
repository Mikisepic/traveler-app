import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/user.model.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthenticationProvider() {
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
        _usersSubscription = firebaseFirestore
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
              markers: (document.data()['markers'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList(),
              trips: (document.data()['trips'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList(),
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

  Future<UserProfileMetadata> getUserProfileMetadataById(String id) async {
    final reference = firebaseFirestore
        .collection('users')
        .doc(id)
        .withConverter(
            fromFirestore: UserProfileMetadata.fromFirestore,
            toFirestore: (UserProfileMetadata userProfileMetadata, _) =>
                userProfileMetadata.toFirestore());

    final snapshot = await reference.get();

    return snapshot.data()!;
  }

  Future<UserProfileMetadata?> getUserProfileMetadataByReference(
      DocumentReference markerRef) async {
    final snapshot = await firebaseFirestore
        .doc(markerRef.path)
        .withConverter<UserProfileMetadata>(
            fromFirestore: UserProfileMetadata.fromFirestore,
            toFirestore: (UserProfileMetadata userProfileMetadata, _) =>
                userProfileMetadata.toFirestore())
        .get();

    return snapshot.data();
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
