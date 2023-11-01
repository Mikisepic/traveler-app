import 'package:flutter/material.dart';

class Marker {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  Marker({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
        id: json['id'] as String,
        title: json['title'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double);
  }
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
