import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/presentation/screens/discover/discover_explore.dart';
import 'package:traveler/presentation/screens/discover/discover_recommended.dart';
import 'package:traveler/services/services.dart';

class ExploreListScreen extends StatefulWidget {
  const ExploreListScreen({super.key});

  @override
  State<ExploreListScreen> createState() => _ExploreListScreenState();
}

class _ExploreListScreenState extends State<ExploreListScreen>
    with TickerProviderStateMixin {
  GeoapifyService geoapifyService = GeoapifyService();
  List<DiscoveryPlace> _discoveryPlaces = [];
  late final TabController _tabController;
  bool loading = false;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);

    getLocationData().then((value) {
      currentLocation = value;
    });
  }

  void _onTabChange() {
    _discoveryPlaces = [];
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

  fetchDiscoveryPlace(double lat, double lng, List<String> categories,
      List<String> conditions) {
    setState(() {
      loading = true;
    });
    loading = true;
    Future<List<DiscoveryPlace>> discoveryPlaces =
        geoapifyService.fetchPlaceSuggestions(lat, lng, categories, conditions);

    discoveryPlaces.then((value) {
      setState(() {
        _discoveryPlaces = value;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Discover',
      appBarBottom: TabBar(controller: _tabController, tabs: const <Widget>[
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
          DiscoverRecommendedScreen(
            places: _discoveryPlaces,
            loading: loading,
            onSelected: (List<String> categories, List<String> conditions) {
              setState(() {
                fetchDiscoveryPlace(
                    currentLocation?.latitude ?? 54.6905948,
                    currentLocation?.longitude ?? 25.2818487,
                    categories,
                    conditions);
              });
            },
          ),
          DiscoverExploreScreen(
            places: _discoveryPlaces,
            loading: loading,
            onSelected: (mapboxMarker, List<String> categories,
                List<String> conditions) {
              fetchDiscoveryPlace(mapboxMarker.coordinates.latitude,
                  mapboxMarker.coordinates.longitude, categories, conditions);
            },
          ),
        ],
      ),
    );
  }
}
