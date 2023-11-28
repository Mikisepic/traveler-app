import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class TripProvider extends ChangeNotifier {
  final List<Trip> _trips = [];

  List<Trip> get trips => _trips;

  Trip fetchOne(String id) {
    final index = _trips.indexWhere((element) => element.id == id);
    return _trips[index];
  }

  void create(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  void update(Trip trip) {
    final index = _trips.indexWhere((trip) => (trip.id == trip.id));

    if (index != -1) {
      _trips[index] = trip;
      notifyListeners();
    }
  }

  void delete(String id) {
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }
}
