import 'package:flutter/material.dart';
import 'package:traveler/screens/wrap.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const WrapScaffold(label: 'Map', body: Text('Map'));
  }
}
