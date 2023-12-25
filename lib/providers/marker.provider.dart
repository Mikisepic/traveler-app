import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class MarkerProvider with ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _markersSubscription;
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  bool _loading = false;
  bool get loading => _loading;

  MarkerProvider() {
    init();
  }

  init() async {
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
          _markers = [];
          _loading = true;
          List<Future<Marker>> futures = [];
          for (final document in snapshot.docs) {
            final localMarker = getMarkerById(document.id);
            futures.add(localMarker);
          }
          _markers = await Future.wait(futures);
          _loading = false;
          notifyListeners();
        });
      } else {
        _markers = [];
      }
      notifyListeners();
    });
  }

  Future<Marker> getMarkerById(String id) async {
    final snapshot = await firebaseFirestore
        .collection('markers')
        .doc(id)
        .withConverter(
            fromFirestore: Marker.fromFirestore,
            toFirestore: (Marker marker, _) => marker.toFirestore())
        .get();

    return snapshot.data()!;
  }

  Future<Marker?> getMarkerByReference(DocumentReference markerRef) async {
    final snapshot = await firebaseFirestore
        .doc(markerRef.path)
        .withConverter<Marker>(
            fromFirestore: Marker.fromFirestore,
            toFirestore: (Marker marker, _) => marker.toFirestore())
        .get();

    return snapshot.data();
  }

  Marker fetchDialogData(String id) {
    final index = _markers.indexWhere((element) => element.id == id);
    return _markers[index];
  }

  create(Marker marker, bool isAuthenticated) {
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
        'markers': FieldValue.arrayUnion([value.id]),
        'updated_at': DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  update(Marker marker) {
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

  delete(String id) {
    firebaseFirestore.collection('markers').doc(id).delete();
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'markers': FieldValue.arrayRemove([id]),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }
}


// 1702905115347
// 1703504308104