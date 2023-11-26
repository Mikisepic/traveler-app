import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/presentation/screens/map/place.dart';
import 'package:traveler/presentation/widgets/widgets.dart';
import 'package:traveler/providers/providers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var random = Random();

  // MapboxMap? mapboxMap;
  // _onMapCreated(MapboxMap mapboxMap) {
  //   mapboxMap = mapboxMap;
  // }

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Map',
      body: Column(
        children: [
          Expanded(
            child: Consumer<MarkerProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.markers.length,
                  itemBuilder: (context, index) {
                    final marker = provider.markers[index];

                    return ListTile(
                      title: Text(marker.title),
                      subtitle: Text(
                          'Latitude: ${marker.latitude}, Longitude: ${marker.longitude}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          provider.removeMarker(marker.id);
                        },
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => SmallDialog(
                          body: Place(
                            marker: marker,
                            onEditComplete: (marker) {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // body: MapWidget(
      //   key: const ValueKey('mapWidget'),
      //   resourceOptions: ResourceOptions(accessToken: accessToken),
      //   onMapCreated: _onMapCreated,
      //   cameraOptions: CameraOptions(
      //       center: Point(
      //           coordinates: Position(
      //         25.2797,
      //         54.6872,
      //       )).toJson(),
      //       zoom: 1.0),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_place'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
