import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class MarkerProvider with ChangeNotifier {
  final List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addMarker(
      String title, String mapboxId, double latitude, double longitude) {
    _markers.add(Marker(
        id: const Uuid().v4(),
        mapboxId: mapboxId,
        title: title,
        latitude: latitude,
        longitude: longitude));
    notifyListeners();
  }

  void removeMarker(String id) {
    _markers.removeWhere((marker) => marker.id == id);
    notifyListeners();
  }

  void editMarker(Marker updatedMarker) {
    final markerIndex =
        _markers.indexWhere((marker) => marker.id == updatedMarker.id);
    if (markerIndex != -1) {
      _markers[markerIndex] = Marker(
        id: updatedMarker.id,
        mapboxId: _markers[markerIndex].mapboxId,
        title: updatedMarker.title,
        latitude: updatedMarker.latitude,
        longitude: updatedMarker.longitude,
      );
      notifyListeners();
    }
  }
}
