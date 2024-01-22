import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:traveler/constants/constants.dart';
import 'package:traveler/providers/providers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(builder: (context, provider, child) {
      return provider.loading
          ? const CircularProgressIndicator()
          : FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: LatLng(
                    ApplicationConstants.vilniusCoordinatesLatitude,
                    ApplicationConstants.vilniusCoordinatesLongitude),
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    LatLng(ApplicationConstants.flutterMapsMinLlatitude,
                        ApplicationConstants.flutterMapsMinLongitude),
                    LatLng(ApplicationConstants.flutterMapsMaxLatitude,
                        ApplicationConstants.flutterMapsMaxLongitude),
                  ),
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/mikisepic1/clqmg0kdf00ph01que0w02n2a/tiles/256/{z}/{x}/{y}@2x?access_token=${ApplicationConstants.mapboxAccessToken}',
                  userAgentPackageName: 'traveller',
                ),
                MarkerLayer(markers: provider.markers),
                PolylineLayer(polylines: provider.polylines),
              ],
            );
    });
  }
}
