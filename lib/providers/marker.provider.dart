import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class MarkerProvider with ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _markersSubscription;

  List<Place> _markers = [];
  List<Place> get markers => _markers;

  bool _loading = false;
  bool get loading => _loading;

  MarkerProvider() {
    init();
  }

  init() {
    firebaseAuth.userChanges().listen((user) {
      _markersSubscription?.cancel();

      if (user != null) {
        _markersSubscription = firebaseFirestore
            .collection('markers')
            .where('userId', isEqualTo: user.uid)
            .orderBy('updated_at', descending: true)
            .limit(10)
            .snapshots()
            .listen((snapshot) async {
          _loading = true;
          _markers = [];
          for (final document in snapshot.docs) {
            final snapshot = await document.reference
                .withConverter(
                    fromFirestore: Place.fromFirestore,
                    toFirestore: (Place marker, _) => marker.toFirestore())
                .get();
            _markers.add(snapshot.data()!);
          }
          _loading = false;
          notifyListeners();
        });
      } else {
        _markers = [];
      }
      notifyListeners();
    });
  }

  Future<Place> getMarkerById(String id) async {
    final snapshot = await firebaseFirestore
        .collection('markers')
        .doc(id)
        .withConverter(
            fromFirestore: Place.fromFirestore,
            toFirestore: (Place marker, _) => marker.toFirestore())
        .get();

    return snapshot.data()!;
  }

  Future<Place?> getMarkerByReference(DocumentReference markerRef) async {
    final snapshot = await firebaseFirestore
        .doc(markerRef.path)
        .withConverter<Place>(
            fromFirestore: Place.fromFirestore,
            toFirestore: (Place marker, _) => marker.toFirestore())
        .get();

    return snapshot.data();
  }

  Place fetchDialogData(String id) {
    final index = _markers.indexWhere((element) => element.id == id);
    return _markers[index];
  }

  create(Place marker, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    final doc = firebaseFirestore.collection('markers').add({
      'userId': firebaseAuth.currentUser!.uid,
      'username': firebaseAuth.currentUser!.displayName,
      'title': marker.title,
      'mapboxId': marker.mapboxId,
      'rating': marker.rating,
      'isFavorite': marker.isFavorite,
      'coordinates': GeoPoint(marker.latitude, marker.longitude),
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });

    doc.then((value) {
      firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'markers': FieldValue.arrayUnion(['markers/${value.id}']),
        'updated_at': DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  update(Place marker) {
    firebaseFirestore.collection('markers').doc(marker.id).update({
      'title': marker.title,
      'userId': firebaseAuth.currentUser!.uid,
      'mapboxId': marker.mapboxId,
      'isFavorite': marker.isFavorite,
      'rating': marker.rating,
      'coordinates': GeoPoint(marker.latitude, marker.longitude),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  delete(String id) async {
    final batch = firebaseFirestore.batch();

    final parentDocRef = firebaseFirestore.collection('markers').doc(id);
    batch.delete(parentDocRef);

    final relatedDocsQuery = firebaseFirestore
        .collection('trips')
        .where('markers', arrayContains: 'markers/$id');
    final relatedDocs = await relatedDocsQuery.get();

    for (final doc in relatedDocs.docs) {
      batch.update(doc.reference, {
        'markers': FieldValue.arrayRemove(['markers/$id']),
        'updated_at': DateTime.now().millisecondsSinceEpoch
      });
    }

    batch.update(
        firebaseFirestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid),
        {
          'markers': FieldValue.arrayRemove(['markers/$id']),
          'updated_at': DateTime.now().millisecondsSinceEpoch
        });

    batch.commit();
  }
}
