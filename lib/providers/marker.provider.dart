import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class MarkerProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _markersSubscription;
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  MarkerProvider() {
    init();
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      _markersSubscription?.cancel();

      if (user != null) {
        _markersSubscription = FirebaseFirestore.instance
            .collection('markers')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _markers = [];
          for (final document in snapshot.docs) {
            _markers.add(
              Marker(
                  id: document.data()['id'] as String,
                  mapboxId: document.data()['mapboxId'] as String,
                  title: document.data()['title'] as String,
                  latitude:
                      (document.data()['coordinates'] as GeoPoint).latitude,
                  longitude:
                      (document.data()['coordinates'] as GeoPoint).longitude,
                  isFavorite: document.data()['isFavorite'] as bool,
                  documentId: document.id),
            );
          }
          notifyListeners();
        });
      } else {
        _markers = [];
      }
      notifyListeners();
    });
  }

  Marker fetchOne(String id) {
    final index = _markers.indexWhere((element) => element.id == id);
    return _markers[index];
  }

  Future<DocumentReference> create(Marker marker, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance.collection('markers').add({
      'id': marker.id,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': FirebaseAuth.instance.currentUser!.displayName,
      'title': marker.title,
      'mapboxId': marker.mapboxId,
      'isFavorite': marker.isFavorite,
      'coordinates': GeoPoint(marker.latitude, marker.longitude),
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void update(Marker marker) {
    final index = _markers.indexWhere((marker) => marker.id == marker.id);
    FirebaseFirestore.instance
        .collection('markers')
        .doc(marker.documentId)
        .set({
      'title': marker.title,
      'mapboxId': marker.mapboxId,
      'isFavorite': marker.isFavorite,
      'coordinates': GeoPoint(marker.latitude, marker.longitude),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });

    if (index != -1) {
      _markers[index] = marker;
      notifyListeners();
    }
  }

  Future<void> delete(String id) {
    return FirebaseFirestore.instance.collection('markers').doc(id).delete();
  }
}
