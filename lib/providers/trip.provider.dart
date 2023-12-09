import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class TripProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _tripsSubscription;
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  TripProvider() {
    init();
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      _tripsSubscription?.cancel();

      if (user != null) {
        _tripsSubscription = FirebaseFirestore.instance
            .collection('trips')
            .orderBy('updated_at', descending: true)
            .snapshots()
            .listen((snapshot) {
          _trips = [];

          for (final document in snapshot.docs) {
            _trips.add(
              Trip(
                id: document.id,
                title: document.data()['title'] as String,
                description: document.data()['description'] as String,
                isPrivate: document.data()['isPrivate'] as bool,
                contributors: document.data()['contributors'] as List<dynamic>,
                markers: document.data()['markers'] as List<dynamic>,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _trips = [];
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    List<DocumentReference> markers = (trip.markers as List<Marker>)
        .map((e) => FirebaseFirestore.instance.collection('markers').doc(e.id))
        .toList();

    return FirebaseFirestore.instance.collection('trips').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      'markers': markers,
      'contributors': trip.contributors as List<DocumentReference>,
      'isPrivate': trip.isPrivate,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void update(Trip trip) {
    List<DocumentReference> markers = (trip.markers as List<Marker>)
        .map((e) => FirebaseFirestore.instance.collection('markers').doc(e.id))
        .toList();

    List<DocumentReference> contributors = (trip.contributors)
        .map((e) =>
            FirebaseFirestore.instance.collection('users').doc(e as String))
        .toList();

    FirebaseFirestore.instance.collection('trips').doc(trip.id).set({
      'title': trip.title,
      'description': trip.description,
      'isPrivate': trip.isPrivate,
      'markers': markers,
      'contributors': contributors,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> delete(String id) {
    return FirebaseFirestore.instance.collection('trips').doc(id).delete();
  }
}
