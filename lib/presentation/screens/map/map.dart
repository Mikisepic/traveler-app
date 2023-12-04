import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/compoennts.dart';
import 'package:traveler/presentation/screens/map/place.dart';
import 'package:traveler/providers/providers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // MapboxMap? mapboxMap;
  // _onMapCreated(MapboxMap mapboxMap) {
  //   mapboxMap = mapboxMap;
  // }

  @override
  Widget build(BuildContext context) {
    Widget listTile(Marker marker, MarkerProvider provider) => ListTile(
          title: Text(marker.title),
          subtitle: Text(
              'Latitude: ${marker.latitude}, Longitude: ${marker.longitude}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(marker.isFavorite ? Icons.star : Icons.star_border),
                color: Colors.red[500],
                onPressed: () {
                  provider.update(Marker(
                      id: marker.id,
                      mapboxId: marker.mapboxId,
                      title: marker.title,
                      latitude: marker.latitude,
                      longitude: marker.longitude,
                      isFavorite: !marker.isFavorite));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  provider.delete(marker.documentId);
                },
              )
            ],
          ),
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => SmallDialog(
              body: Place(
                id: marker.id,
                onEditComplete: (marker) {
                  context.read<MarkerProvider>().update(marker);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );

    return WrapScaffold(
      label: 'Map',
      body: Column(
        children: [
          Expanded(
            child: Consumer<MarkerProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.markers.length,
                  itemBuilder: (context, index) =>
                      listTile(provider.markers[index], provider),
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
