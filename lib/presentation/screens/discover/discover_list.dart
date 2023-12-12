import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/presentation/screens/discover/discover_explore.dart';
import 'package:traveler/presentation/screens/discover/discover_recommended.dart';

class ExploreListScreen extends StatefulWidget {
  const ExploreListScreen({super.key});

  @override
  State<ExploreListScreen> createState() => _ExploreListScreenState();
}

class _ExploreListScreenState extends State<ExploreListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  LocationData? currentLocation;
  List<String> selectedCategories = ['activity'];

  @override
  void initState() {
    super.initState();
    getLocationData().then((value) {
      currentLocation = value;
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<LocationData?> getLocationData() async {
    var location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Discover',
      bottomAppBar: TabBar(controller: _tabController, tabs: const <Widget>[
        Tab(
          icon: Icon(Icons.person),
          text: 'For me',
        ),
        Tab(
          icon: Icon(Icons.search),
          text: 'Explore',
        ),
      ]),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DiscoverExploreScreen(locationData: currentLocation),
          DiscoverRecommendedScreen(categories: selectedCategories)
        ],
      ),
    );
  }
}
