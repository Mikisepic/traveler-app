import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class TripProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _tripsSubscription;
  bool _loading = false;
  bool get loading => _loading;
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  final Trip _trip = Trip(
    id: '',
    title: '',
  );
  Trip get trip => _trip;

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
          _loading = true;
          for (final document in snapshot.docs) {
            _trips.add(Trip(
              id: document.id,
              title: document.data()['title'] as String,
              description: document.data()['description'] as String,
              isPrivate: document.data()['isPrivate'] as bool,
              contributors: document.data()['contributors'] as List<dynamic>,
              markers: (document.data()['markers'] as List<dynamic>)
                  .map((e) => Marker(
                      id: e['id'] as String,
                      title: e['title'] as String,
                      mapboxId: '',
                      latitude: 0,
                      longitude: 0))
                  .toList(),
            ));
          }
          _loading = false;
          notifyListeners();
        });
      } else {
        _trips = [];
      }
      notifyListeners();
    });
  }

  Trip fetchDialogData(String id) {
    final index = _trips.indexWhere((element) => element.id == id);
    return _trips[index];
  }

  Future<DocumentReference> create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('trips').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.id),
      'contributors': trip.isPrivate
          ? [FirebaseAuth.instance.currentUser!.uid]
          : [
              FirebaseAuth.instance.currentUser!.uid,
              ...trip.contributors.map((e) => e.id)
            ],
      'isPrivate': trip.isPrivate,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void update(Trip trip) {
    FirebaseFirestore.instance.collection('trips').doc(trip.id).update({
      'title': trip.title,
      'description': trip.description,
      'isPrivate': trip.isPrivate,
      'markers': trip.markers,
      'contributors': trip.contributors,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> delete(String id) {
    return FirebaseFirestore.instance.collection('trips').doc(id).delete();
  }
}
