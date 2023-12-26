import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:traveler/constants/app_constants.dart';
import 'package:traveler/providers/providers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: const LatLng(54.6905948, 25.2818487),
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(-90, -180),
            const LatLng(90, 180),
          ),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/mikisepic1/clqmg0kdf00ph01que0w02n2a/tiles/256/{z}/{x}/{y}@2x?access_token=${ApplicationConstants.mapboxAccessToken}',
          userAgentPackageName: 'traveller',
        ),
        Consumer<MapProvider>(builder: (context, provider, child) {
          return PolylineLayer(polylines: [
            Polyline(
                points: provider.polylinePoints,
                color: Colors.blue,
                strokeWidth: 2),
          ]);
        }),
        Consumer<MapProvider>(builder: (context, provider, child) {
          return MarkerLayer(markers: provider.markers);
        }),
      ],
    );
  }
}
