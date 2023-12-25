import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/marker.provider.dart';

class TripProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _tripsSubscription;
  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  TripProvider() {
    init();
  }

  init() async {
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
            _trips.add(Trip(
              id: document.id,
              title: document.data()['title'] as String,
              description: document.data()['description'] as String,
              isPrivate: document.data()['isPrivate'] as bool,
              contributors: (document.data()['contributors'] as List<dynamic>)
                  .map((e) => UserProfileMetadata(
                      id: e['userId'] as String,
                      email: e['email'] as String,
                      displayName: e['displayName'] as String))
                  .toList(),
              markers: (document.data()['markers'] as List<dynamic>)
                  .map((e) => Marker(
                      id: e['id'] as String,
                      title: e['title'] as String,
                      mapboxId: e['mapboxId'] as String,
                      latitude: e['latitude'] as double,
                      longitude: e['longitude'] as double,
                      rating: e['rating'] as int))
                  .toList(),
              // markers: (document.data()['markers'] as List<dynamic>)
              //     .map((e) => FirebaseFirestore.instance.doc(e.toString()))
              //     .toList(),
            ));
          }
          notifyListeners();
        });
      } else {
        _trips = [];
      }
      notifyListeners();
    });
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
      Future<Marker> associatedMarker =
          MarkerProvider().getMarkerByReference(ref);
      associatedMarker.then((value) => receivedMarkers.add(value));
    }

    return receivedMarkers;
  }

  create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    final doc = FirebaseFirestore.instance.collection('trips').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      // 'markers': trip.markers,
      'markers': trip.markers.map((e) => e.toFirestore()).toList(),
      'contributors': trip.isPrivate
          ? [
              {
                "userId": FirebaseAuth.instance.currentUser!.uid,
                "email": FirebaseAuth.instance.currentUser!.email,
                "displayName": FirebaseAuth.instance.currentUser!.displayName,
              }
            ]
          : [
              {
                "userId": FirebaseAuth.instance.currentUser!.uid,
                "email": FirebaseAuth.instance.currentUser!.email,
                "displayName": FirebaseAuth.instance.currentUser!.displayName,
              },
              ...trip.contributors.map((e) => e.toFirestore()).toList()
            ],
      'isPrivate': trip.isPrivate,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });

    doc.then((value) => FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'trips': FieldValue.arrayUnion([value.id]),
          'updated_at': DateTime.now().millisecondsSinceEpoch
        }));
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

  delete(String id) {
    FirebaseFirestore.instance.collection('trips').doc(id).delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'trips': FieldValue.arrayRemove([id]),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }
}
