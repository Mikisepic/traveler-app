import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class MarkerProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _markersSubscription;
  bool _loading = false;
  bool get loading => _loading;
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  MarkerProvider(
      {required this.firebaseFirestore, required this.firebaseAuth}) {
    init();
  }

  Future<void> init() async {
    firebaseAuth.userChanges().listen((user) {
      _markersSubscription?.cancel();

      if (user != null) {
        _markersSubscription = firebaseFirestore
            .collection('markers')
            .where('userId', isEqualTo: user.uid)
            .orderBy('updated_at', descending: true)
            .limit(10)
            .snapshots()
            .listen((snapshot) {
          _markers = [];
          _loading = true;
          for (final document in snapshot.docs) {
            _markers.add(
              Marker(
                id: document.id,
                mapboxId: document.data()['mapboxId'] as String,
                title: document.data()['title'] as String,
                latitude: (document.data()['coordinates'] as GeoPoint).latitude,
                longitude:
                    (document.data()['coordinates'] as GeoPoint).longitude,
                isFavorite: document.data()['isFavorite'] as bool,
              ),
            );
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

  Future<Marker?> fetchOne(String id) async {
    final reference = firebaseFirestore
        .collection('markers')
        .doc(id)
        .withConverter(
            fromFirestore: Marker.fromFirestore,
            toFirestore: (Marker marker, _) => marker.toFirestore());

    var docSnap = await reference.get();
    final marker = docSnap.data();

    if (marker != null) {
      return marker;
    }
    return null;
  }

  Marker fetchDialogData(String id) {
    final index = _markers.indexWhere((element) => element.id == id);
    return _markers[index];
  }

  create(Marker marker, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance.collection('markers').add({
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

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'markers': FieldValue.arrayUnion([marker.id])
    });
  }

  void update(Marker marker) {
    FirebaseFirestore.instance.collection('markers').doc(marker.id).update({
      'title': marker.title,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'mapboxId': marker.mapboxId,
      'isFavorite': marker.isFavorite,
      'coordinates': GeoPoint(marker.latitude, marker.longitude),
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  delete(String id) {
    FirebaseFirestore.instance.collection('markers').doc(id).delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'markers': FieldValue.arrayRemove([id])
    });
  }
}
