import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveler/models/models.dart';

class MapProvider extends ChangeNotifier {
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;

  List<LatLng> _polylinePoints = [];
  List<LatLng> get polylinePoints => _polylinePoints;

  bool _loading = false;
  bool get loading => _loading;

  void initMarkers(List<Place> places) {
    _loading = true;
    _polylinePoints = [];
    _markers = places
        .map((place) => Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(place.latitude, place.longitude),
              child: Tooltip(
                  message: place.title,
                  child: const Icon(
                    Icons.location_on,
                    size: 40.0,
                  )),
            ))
        .toList();
    _loading = false;
    notifyListeners();
  }

  void drawOptimizationPolylines(TripOptimization optimization) {
    _loading = true;
    _polylinePoints = [];
    for (var leg in optimization.trips[0].legs) {
      for (var step in leg.steps) {
        _polylinePoints.addAll(
          step.geometry.coordinates
              .map((coordinate) => LatLng(coordinate[1], coordinate[0])),
        );
      }
    }
    _loading = false;
    notifyListeners();
  }
}
