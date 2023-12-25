import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/authentication.provider.dart';
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
            .where('contributors', arrayContains: user.uid)
            .orderBy('updated_at', descending: true)
            .snapshots()
            .listen((snapshot) async {
          _trips = [];
          _loading = true;
          for (final document in snapshot.docs) {
            final snapshot = await document.reference
                .withConverter(
                    fromFirestore: Trip.fromFirestore,
                    toFirestore: (Trip trip, _) => trip.toFirestore())
                .get();
            _trips.add(snapshot.data()!);
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

  List<Marker> fetchTripMarkers(List<DocumentReference> refs) {
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

  List<UserProfileMetadata> fetchTripContributors(
      List<DocumentReference> refs) {
    List<UserProfileMetadata> tripContributors = [];

    for (DocumentReference ref in refs) {
      Future<UserProfileMetadata?> associatedMarker =
          AuthenticationProvider().getUserProfileMetadataByReference(ref);
      associatedMarker.then((value) {
        if (value != null) {
          tripContributors.add(value);
        }
      });
    }

    return tripContributors;
  }

  create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    final doc = firebaseFirestore.collection('trips').add({
      'userId': firebaseAuth.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.path).toList(),
      'contributors': trip.isPrivate
          ? ['users/${firebaseAuth.currentUser!.uid}']
          : [
              'users/${firebaseAuth.currentUser!.uid}',
              ...trip.contributors.map((e) => e.path).toList()
            ],
      'isPrivate': trip.isPrivate,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });

    doc.then((value) => FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'trips': FieldValue.arrayUnion(['trips/${value.id}']),
          'updated_at': DateTime.now().millisecondsSinceEpoch
        }));
  }

  update(Trip trip) {
    firebaseFirestore.collection('trips').doc(trip.id).update({
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.path).toList(),
      'contributors': trip.isPrivate
          ? ['users/${firebaseAuth.currentUser!.uid}']
          : [
              'users/${firebaseAuth.currentUser!.uid}',
              ...trip.contributors.map((e) => e.path).toList()
            ],
      'isPrivate': trip.isPrivate,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  delete(String id) {
    firebaseFirestore.collection('trips').doc(id).delete();
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'trips': FieldValue.arrayRemove(['trips/$id']),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }
}
