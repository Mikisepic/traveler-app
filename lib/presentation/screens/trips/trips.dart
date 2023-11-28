import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/wrap.dart';
import 'package:traveler/providers/providers.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget card(Trip trip) => Card(
          margin: const EdgeInsets.all(10.0),
          color: Theme.of(context).cardColor,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              trip.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              trip.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () =>
                context.goNamed('trip', pathParameters: {'tripId': trip.id}),
          ),
        );

    return WrapScaffold(
      label: 'Trips',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Consumer<TripProvider>(builder: (context, provider, child) {
              return ListView.builder(
                  itemCount: provider.trips.length,
                  itemBuilder: (context, index) => card(provider.trips[index]));
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_trip'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
