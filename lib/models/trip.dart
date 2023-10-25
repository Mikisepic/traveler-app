import 'package:flutter/material.dart';

import 'marker.dart';

class Trip {
  final String id;
  final String title;
  final String description;
  final List<Marker> markers;

  Trip(
      {required this.id,
      required this.title,
      required this.description,
      required this.markers});
}

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];

  List<Trip> get trips => _trips;

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void removeOne(String id) {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }

  void editTrip(
      String id, String title, String description, List<Marker> markers) {
    final tripIndex = _trips.indexWhere((trip) => (trip.id == id));

    if (tripIndex != -1) {
      _trips[tripIndex] = Trip(
          id: id, title: title, description: description, markers: markers);
    }
    notifyListeners();
  }
}
