import 'package:flutter/material.dart';
import 'package:traveler/presentation/components/wrap.dart';

class TripDetailsScreen extends StatefulWidget {
  final String id;

  const TripDetailsScreen({super.key, required this.id});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: widget.id,
      body: const Padding(
        padding: EdgeInsets.all(40.0),
        child: Text('Trip'),
      ),
    );
  }
}
