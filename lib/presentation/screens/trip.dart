import 'package:flutter/material.dart';
import 'package:traveler/presentation/widgets/wrap.dart';

class TripDetailsScreen extends StatefulWidget {
  final String id;

  const TripDetailsScreen({super.key, required this.id});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  String tripTitle = 'Summer Vacation';
  String tripDate = 'July 10, 2023 - July 20, 2023';

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: widget.id,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip Title:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Text(
              tripTitle,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Trip Date:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Text(
              tripDate,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
