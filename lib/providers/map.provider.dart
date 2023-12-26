import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveler/models/marker.model.dart';

class MapProvider extends ChangeNotifier {
  List<Marker> _markers = [];
  List<Marker> get markers => _markers;
  List<LatLng> _polylinePoints = [];
  List<LatLng> get polylinePoints => _polylinePoints;

  void initMarkers(List<Place> places) {
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
    _polylinePoints = [];
  }
}
