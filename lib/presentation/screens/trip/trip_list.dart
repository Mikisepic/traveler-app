import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/wrap.dart';
import 'package:traveler/providers/providers.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  @override
  Widget build(BuildContext context) {
    Widget card(Trip trip, TripProvider provider) => Card(
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: Text('Delete ${trip.title}?'),
                                content: const Text(
                                    'Are you sure you want to delete?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      provider.delete(trip.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                ])))
              ],
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
                  itemBuilder: (context, index) =>
                      card(provider.trips[index], provider));
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.goNamed('new_trip'),
      ),
    );
  }
}
