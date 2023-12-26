import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveler/constants/app_constants.dart';
import 'package:traveler/presentation/components/components.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({super.key});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  List<Marker> markers = [];
  List<LatLng> polylinePoints = [];

  @override
  Widget build(BuildContext context) {
    // Widget listTile(Place marker, MarkerProvider provider) => ListTile(
    //       title: Text(marker.title),
    //       subtitle: Text(
    //           'Latitude: ${marker.latitude}, Longitude: ${marker.longitude}'),
    //       trailing: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           IconButton(
    //             icon: Icon(marker.isFavorite ? Icons.star : Icons.star_border),
    //             color: Colors.red[500],
    //             onPressed: () {
    //               provider.update(Place(
    //                   id: marker.id,
    //                   mapboxId: marker.mapboxId,
    //                   title: marker.title,
    //                   latitude: marker.latitude,
    //                   longitude: marker.longitude,
    //                   isFavorite: !marker.isFavorite));
    //             },
    //           ),
    //           IconButton(
    //               icon: const Icon(Icons.delete),
    //               onPressed: () => showDialog(
    //                   context: context,
    //                   builder: (BuildContext context) => AlertDialog(
    //                           title: Text('Delete ${marker.title}?'),
    //                           content: const Text(
    //                               'Are you sure you want to delete?'),
    //                           actions: <Widget>[
    //                             TextButton(
    //                               onPressed: () {
    //                                 provider.delete(marker.id);
    //                                 Navigator.of(context).pop();
    //                               },
    //                               child: const Text('Yes'),
    //                             ),
    //                             TextButton(
    //                               onPressed: () {
    //                                 Navigator.of(context).pop();
    //                               },
    //                               child: const Text('No'),
    //                             ),
    //                           ])))
    //         ],
    //       ),
    //       onTap: () => showDialog<String>(
    //         context: context,
    //         builder: (BuildContext context) => SmallDialog(
    //           body: PlaceViewScreen(
    //             id: marker.id,
    //             onEditComplete: (marker) {
    //               context.read<MarkerProvider>().update(marker);
    //               Navigator.pop(context);
    //             },
    //           ),
    //         ),
    //       ),
    //     );

    void addMarker(LatLng point) {
      Marker marker = Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          child: const Icon(
            Icons.location_on,
            size: 40.0,
          ));

      markers.add(marker);
      polylinePoints.add(point);

      (context as Element).markNeedsBuild();
    }

    return WrapScaffold(
      label: 'Map',
      // body: context.read<MarkerProvider>().loading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Column(
      //         children: [
      //           Expanded(
      //             child: Consumer<MarkerProvider>(
      //               builder: (context, provider, child) {
      //                 return provider.loading
      //                     ? const CircularProgressIndicator()
      //                     : ListView.builder(
      //                         itemCount: provider.markers.length,
      //                         itemBuilder: (context, index) =>
      //                             listTile(provider.markers[index], provider),
      //                       );
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: const LatLng(54.6905948, 25.2818487),
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
          onLongPress: (TapPosition tapPosition, LatLng tapPoint) {
            addMarker(tapPoint);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mikisepic1/clqmg0kdf00ph01que0w02n2a/tiles/256/{z}/{x}/{y}@2x?access_token=${ApplicationConstants.mapboxAccessToken}',
            userAgentPackageName: 'traveller',
          ),
          PolylineLayer(polylines: [
            Polyline(
                points: polylinePoints, color: Colors.blue, strokeWidth: 2),
          ]),
          MarkerLayer(markers: markers)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_place'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
