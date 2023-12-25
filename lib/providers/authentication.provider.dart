import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
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
  bool _loading = false;
  bool get loading => _loading;

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
            .snapshots()
            .listen((snapshot) async {
          _loading = true;
          _users = [];
          List<Future<UserProfileMetadata>> futures = [];
          for (final document in snapshot.docs) {
            final futureUser = getUserProfileMetadataById(document.id);
            futures.add(futureUser);
          }
          _users = await Future.wait(futures);
          _userMetadata =
              _users.firstWhere((element) => element.id == user!.uid);
          _loading = false;
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
