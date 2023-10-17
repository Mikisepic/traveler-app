import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/common/constants.dart';
import 'package:traveler/models/marker.dart';
import 'package:traveler/presentation/widgets/wrap.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  var random = Random();

  _onMapCreated(MapboxMap mapboxMap) {
    mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    final markerProvider = Provider.of<MarkerProvider>(context);

    return WrapScaffold(
      label: 'Map',
      // body: Column(
      //   children: [
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: markerProvider.markers.length,
      //         itemBuilder: (context, index) {
      //           final marker = markerProvider.markers[index];
      //           return ListTile(
      //             title: Text('Marker ${marker.id}'),
      //             subtitle: Text(
      //                 'Latitude: ${marker.latitude}, Longitude: ${marker.longitude}'),
      //             trailing: IconButton(
      //               icon: const Icon(Icons.delete),
      //               onPressed: () {
      //                 markerProvider.removeMarker(marker.id);
      //               },
      //             ),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: MapWidget(
        key: const ValueKey('mapWidget'),
        resourceOptions: ResourceOptions(accessToken: accessToken),
        onMapCreated: _onMapCreated,
        cameraOptions: CameraOptions(
            center: Point(
                coordinates: Position(
              25.2797,
              54.6872,
            )).toJson(),
            zoom: 1.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final random = Random();
          final randomLatitude = 40 + random.nextDouble() * 10;
          final randomLongitude = -90 + random.nextDouble() * 20;

          markerProvider.addMarker(
            Marker(
              id: const Uuid().v4(),
              latitude: randomLatitude,
              longitude: randomLongitude,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
