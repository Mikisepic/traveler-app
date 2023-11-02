import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class MarkerProvider with ChangeNotifier {
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addMarker(String title, double latitude, double longitude) {
    _markers.add(Marker(
        id: const Uuid().v4(),
        title: title,
        latitude: latitude,
        longitude: longitude));
    notifyListeners();
  }

  void removeMarker(String id) {
    _markers.removeWhere((marker) => marker.id == id);
    notifyListeners();
  }

  void editMarker(
      String id, String title, double newLatitude, double newLongitude) {
    final markerIndex = _markers.indexWhere((marker) => marker.id == id);
    if (markerIndex != -1) {
      _markers[markerIndex] = Marker(
        id: id,
        title: title,
        latitude: newLatitude,
        longitude: newLongitude,
      );
      notifyListeners();
    }
  }
}
