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
      'isPrivate': trip.isPrivate,
      'markers': markers,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void update(Trip trip) {
    final index = _trips.indexWhere((trip) => (trip.id == trip.id));

    if (index != -1) {
      _trips[index] = trip;
      notifyListeners();
    }
  }

  void delete(String id) {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }
}
