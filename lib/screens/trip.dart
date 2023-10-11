import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveler/screens/wrap.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Trips',
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                  10,
                  (index) => Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Item $index',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateTime.now().toUtc().toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          onTap: () => context.goNamed('trip',
                              pathParameters: {'tripId': index.toString()}),
                        ),
                      )),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
