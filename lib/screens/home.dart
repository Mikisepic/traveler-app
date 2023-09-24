import 'package:flutter/material.dart';
import 'package:traveler/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: const Text('Traveller'),
        ),
        body: const TabBarView(
          children: [
            ProfileScreen(),
            MapScreen(),
            TripsScreen(),
          ],
        ),
      ),
    );
  }
}
