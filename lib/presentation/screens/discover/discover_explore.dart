import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/authentication.provider.dart';
import 'package:traveler/providers/marker.provider.dart';

class DiscoverExploreScreen extends StatefulWidget {
  final LocationData? locationData;
  final List<DiscoveryPlace> places;
  final List<String> selectedCategories;

  const DiscoverExploreScreen(
      {super.key,
      required this.locationData,
      required this.places,
      required this.selectedCategories});

  @override
  State<DiscoverExploreScreen> createState() => _DiscoverExploreScreenState();
}

class _DiscoverExploreScreenState extends State<DiscoverExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      MultiSelectDialogField<String>(
        items: const [],
        initialValue: widget.selectedCategories,
        listType: MultiSelectListType.CHIP,
        searchable: true,
        onConfirm: (values) {
          print(values);
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            print(value);
            // setState(() {
            //   selectedMarkers.remove(value);
            // });
          },
        ),
      ),
      ListView.builder(
        itemCount: widget.places.length,
        itemBuilder: (context, index) => Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.place),
                title: Text(widget.places[index].properties.name),
                subtitle: Text(
                    '${widget.places[index].properties.country}, ${widget.places[index].properties.state}, ${widget.places[index].properties.county}, ${widget.places[index].properties.city}'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Add Place'),
                    onPressed: () {
                      context.read<MarkerProvider>().create(
                          Marker(
                              mapboxId: '',
                              title: widget.places[index].properties.name,
                              latitude: widget.places[index].properties.lat,
                              longitude: widget.places[index].properties.lon),
                          context
                              .read<AuthenticationProvider>()
                              .isAuthenticated);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
