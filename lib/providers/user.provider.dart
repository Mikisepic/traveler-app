import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  List<UserProfileMetadata> _users = [];
  List<UserProfileMetadata> get users => _users;
  StreamSubscription<QuerySnapshot>? _usersSubscription;

  UserProfileMetadata _user = UserProfileMetadata(
    id: const Uuid().v4(),
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    trips: [],
    markers: [],
    about:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  );
  UserProfileMetadata get user => _user;

  UserProvider() {
    init();
  }

  init() {
    FirebaseAuth.instance.userChanges().listen((user) {
      _usersSubscription?.cancel();

      if (user != null) {
        _usersSubscription = FirebaseFirestore.instance
            .collection('users')
            .orderBy('updated_at', descending: true)
            .snapshots()
            .listen((snapshot) {
          _users = [];
          for (final document in snapshot.docs) {
            _users.add(UserProfileMetadata(
              id: document.id,
              email: document.data()['email'] as String,
            ));
          }
          notifyListeners();
        });
      } else {
        _users = [];
      }
      notifyListeners();
    });
  }

  void updateUserDetails(String newFirstName, String newLastName,
      String newEmail, String newAbout) {
    _user = UserProfileMetadata(
        id: _user.id,
        firstName: newFirstName,
        lastName: newLastName,
        email: newEmail,
        trips: _user.trips,
        markers: _user.markers,
        about: newAbout);
    notifyListeners();
  }
}
