import 'package:flutter/material.dart';
import 'package:traveler/screens/wrap.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key, this.id = ''});

  final String? id;

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  Widget build(BuildContext context) {
    return const WrapScaffold(label: 'Trips', body: Text('Trips'));
  }
}
