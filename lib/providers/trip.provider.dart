import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/providers.dart';

class TripProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _tripsSubscription;

  List<Trip> _trips = [];
  List<Trip> get trips => _trips;

  Trip? _trip;
  Trip? get trip => _trip;

  List<Place> _tripMarkers = [];
  List<Place> get tripMarkers => _tripMarkers;

  List<UserProfileMetadata> _tripContributors = [];
  List<UserProfileMetadata> get tripContributors => _tripContributors;

  List<Note> _tripNotes = [];
  List<Note> get tripNotes => _tripNotes;

  List<Reminder> _tripReminders = [];
  List<Reminder> get tripReminders => _tripReminders;

  bool _loading = false;
  bool get loading => _loading;

  TripProvider() {
    init();
  }

  void init() {
    firebaseAuth.userChanges().listen((user) {
      _tripsSubscription?.cancel();

      if (user != null) {
        _tripsSubscription = firebaseFirestore
            .collection('trips')
            .where('contributors', arrayContains: 'users/${user.uid}')
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

  Future<void> fetchTrip(String id) async {
    _loading = true;
    final currentTrip = await getTripById(id);
    _trip = currentTrip;
    _loading = false;
  }

  Future<void> fetchTripMarkers(List<DocumentReference> refs) async {
    _loading = true;
    _tripMarkers = [];
    List<Future<Place>> futures = [];
    for (DocumentReference ref in refs) {
      Future<Place> associatedMarker =
          PlaceProvider().getMarkerByReference(ref);
      futures.add(associatedMarker);
    }
    _tripMarkers = await Future.wait(futures);
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchTripContributors(List<DocumentReference> refs) async {
    _loading = true;
    _tripContributors = [];
    List<Future<UserProfileMetadata>> futures = [];
    for (DocumentReference ref in refs) {
      Future<UserProfileMetadata> associatedContributor =
          AuthenticationProvider().getUserProfileMetadataByReference(ref);
      futures.add(associatedContributor);
    }
    _tripContributors = await Future.wait(futures);
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchTripNotes(List<DocumentReference> refs) async {
    _loading = true;
    _tripNotes = [];
    List<Future<Note>> futures = [];
    for (DocumentReference ref in refs) {
      Future<Note> associatedNote = NoteProvider().getNoteByReference(ref);
      futures.add(associatedNote);
    }
    _tripNotes = await Future.wait(futures);
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchTripReminders(List<DocumentReference> refs) async {
    _loading = true;
    _tripReminders = [];
    List<Future<Reminder>> futures = [];
    for (DocumentReference ref in refs) {
      Future<Reminder> associatedReminder =
          ReminderProvider().getReminderByReference(ref);
      futures.add(associatedReminder);
    }
    _tripReminders = await Future.wait(futures);
    _loading = false;
    notifyListeners();
  }

  void create(Trip trip, bool isAuthenticated) {
    if (!isAuthenticated) {
      throw Exception('Must be logged in');
    }

    final doc = firebaseFirestore.collection('trips').add({
      'userId': firebaseAuth.currentUser!.uid,
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.path).toList(),
      'contributors': trip.contributors.map((e) => e.path).toList(),
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

  void update(Trip trip) {
    firebaseFirestore.collection('trips').doc(trip.id).update({
      'title': trip.title,
      'description': trip.description,
      'markers': trip.markers.map((e) => e.path).toList(),
      'contributors': trip.contributors.map((e) => e.path).toList(),
      'isPrivate': trip.isPrivate,
      'updated_at': DateTime.now().millisecondsSinceEpoch
    });
  }

  void delete(String id) {
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
