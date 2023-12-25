import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/marker.provider.dart';

class TripProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _tripsSubscription;
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;
  bool _loading = false;
  bool get loading => _loading;

  TripProvider() {
    init();
  }

  init() {
    firebaseAuth.userChanges().listen((user) {
      _tripsSubscription?.cancel();

      if (user != null) {
        _tripsSubscription = firebaseFirestore
            .collection('trips')
            .orderBy('updated_at', descending: true)
            .snapshots()
            .listen((snapshot) async {
          _trips = [];
          _loading = true;
          List<Future<Trip>> futures = [];
          for (final document in snapshot.docs) {
            final localTrip = getTripById(document.id);
            futures.add(localTrip);
          }
          _trips = await Future.wait(futures);
          _loading = false;
          notifyListeners();
        });
      } else {
        _trips = [];
      }
      notifyListeners();
    });
  }

  Future<Trip> getTripById(String id) async {
    final reference = firebaseFirestore
        .collection('trips')
        .doc(id)
        .withConverter(
            fromFirestore: Trip.fromFirestore,
            toFirestore: (Trip trip, _) => trip.toFirestore());

    final snapshot = await reference.get();

    return snapshot.data()!;
  }

  Future<Trip> getTripByReference(DocumentReference tripRef) async {
    final snapshot = await tripRef
        .withConverter<Trip>(
            fromFirestore: Trip.fromFirestore,
            toFirestore: (Trip trip, _) => trip.toFirestore())
        .get();

    return snapshot.data()!;
  }

  Trip fetchDialogData(String id) {
    final index = _trips.indexWhere((element) => element.id == id);
    return _trips[index];
  }

  List<Marker> fetchTripMarkerData(List<DocumentReference> refs) {
    List<Marker> receivedMarkers = [];

    for (DocumentReference ref in refs) {
      Future<Marker?> associatedMarker =
          MarkerProvider().getMarkerByReference(ref);
      associatedMarker.then((value) {
        if (value != null) {
          receivedMarkers.add(value);
        }
      });
    }

    return receivedMarkers;
  }

  create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    final doc = firebaseFirestore.collection('trips').add({
      'userId': firebaseAuth.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.path),
      'contributors': trip.isPrivate
          ? [
              {
                "userId": firebaseAuth.currentUser!.uid,
                "email": firebaseAuth.currentUser!.email,
                "displayName": firebaseAuth.currentUser!.displayName,
              }
            ]
          : [
              {
                "userId": firebaseAuth.currentUser!.uid,
                "email": firebaseAuth.currentUser!.email,
                "displayName": firebaseAuth.currentUser!.displayName,
              },
              ...trip.contributors.map((e) => e.toFirestore()).toList()
            ],
      'isPrivate': trip.isPrivate,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });

    doc.then((value) => FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'trips': FieldValue.arrayUnion([value.id]),
          'updated_at': DateTime.now().millisecondsSinceEpoch
        }));
  }

  void update(Trip trip) {
    firebaseFirestore.collection('trips').doc(trip.id).update({
      'title': trip.title,
      'description': trip.description,
      'isPrivate': trip.isPrivate,
      'markers': trip.markers,
      'contributors': trip.contributors,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  delete(String id) {
    firebaseFirestore.collection('trips').doc(id).delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'trips': FieldValue.arrayRemove([id]),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }
}
