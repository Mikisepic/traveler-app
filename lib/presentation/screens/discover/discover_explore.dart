import 'package:flutter/material.dart';
import 'package:location/location.dart';

class DiscoverExploreScreen extends StatefulWidget {
  final LocationData? locationData;

  const DiscoverExploreScreen({super.key, required this.locationData});

  @override
  State<DiscoverExploreScreen> createState() => _DiscoverExploreScreenState();
}

class _DiscoverExploreScreenState extends State<DiscoverExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("It's cloudy here"),
    );
  }

  getLocationData() async {
    var location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }
}
