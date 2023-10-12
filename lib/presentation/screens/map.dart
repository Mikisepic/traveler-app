import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:traveler/common/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey('mapWidget'),
      resourceOptions: ResourceOptions(accessToken: accessToken),
      onMapCreated: _onMapCreated,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-80.1263, 25.7845)).toJson(),
          zoom: 12.0),
    );
  }
}
