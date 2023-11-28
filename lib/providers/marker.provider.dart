import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

class MarkerProvider with ChangeNotifier {
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  Marker fetchOne(String id) {
    final index = _markers.indexWhere((element) => element.id == id);
    return _markers[index];
  }

  void create(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void update(Marker marker) {
    final index = _markers.indexWhere((marker) => marker.id == marker.id);

    if (index != -1) {
      _markers[index] = marker;
      notifyListeners();
    }
  }

  void delete(String id) {
    _markers.removeWhere((marker) => marker.id == id);
    notifyListeners();
  }
}
