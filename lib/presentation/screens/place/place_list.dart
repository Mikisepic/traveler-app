import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/presentation/screens/place/place.dart';
import 'package:traveler/providers/providers.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({super.key});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  @override
  Widget build(BuildContext context) {
    Widget listTile(Place marker, PlaceProvider provider) => ListTile(
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
                  provider.update(Place(
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
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                              title: Text('Delete ${marker.title}?'),
                              content: const Text(
                                  'Are you sure you want to delete?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    provider.delete(marker.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                              ])))
            ],
          ),
          onTap: () async {
            await provider.fetchDialogData(marker.id);
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (BuildContext context) => SmallDialog(
                body: PlaceViewScreen(
                  id: marker.id,
                  onEditComplete: (marker) {
                    context.read<PlaceProvider>().update(marker);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );

    return WrapScaffold(
      appBarLeading: IconButton(
          onPressed: () {
            context
                .read<MapProvider>()
                .initMarkers(context.read<PlaceProvider>().markers);
            showDialog(
                context: context,
                builder: (BuildContext context) => const Dialog(
                      child: MapScreen(),
                    ));
          },
          icon: const Icon(Icons.map_outlined)),
      label: 'Places',
      body: context.read<PlaceProvider>().loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Consumer<PlaceProvider>(
                    builder: (context, provider, child) {
                      return provider.loading
                          ? const CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: provider.markers.length,
                              itemBuilder: (context, index) =>
                                  listTile(provider.markers[index], provider),
                            );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_place'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
