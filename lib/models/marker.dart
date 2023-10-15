import 'package:flutter/material.dart';

class Marker {
  final String id;
  final double latitude;
  final double longitude;

  Marker({
    required this.id,
    required this.latitude,
    required this.longitude,
  });
}

class MarkerProvider with ChangeNotifier {
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeMarker(String id) {
    _markers.removeWhere((marker) => marker.id == id);
    notifyListeners();
  }

  void editMarker(String id, double newLatitude, double newLongitude) {
    final markerIndex = _markers.indexWhere((marker) => marker.id == id);
    if (markerIndex != -1) {
      _markers[markerIndex] = Marker(
        id: id,
        latitude: newLatitude,
        longitude: newLongitude,
      );
      notifyListeners();
    }
  }
}
