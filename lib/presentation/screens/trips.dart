import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/trip.dart';
import 'package:traveler/presentation/widgets/wrap.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Consumer<TripProvider>(builder: (context, provider, child) {
              return ListView.builder(
                  itemCount: provider.trips.length,
                  itemBuilder: (context, index) {
                    final trip = provider.trips[index];

                    return Card(
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
                        onTap: () => context.goNamed('trip',
                            pathParameters: {'tripId': trip.id}),
                      ),
                    );
                  });
            }),
          )
        ],
      ),
      // body: Padding(
      //     padding: const EdgeInsets.all(40.0),
      //     child: LayoutBuilder(builder: (context, constraints) {
      //       return SingleChildScrollView(
      //         child: ConstrainedBox(
      //           constraints: BoxConstraints(minHeight: constraints.maxHeight),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             crossAxisAlignment: CrossAxisAlignment.stretch,
      //             children: [
      //               Expanded(
      //                   child: ListView.builder(
      //                       itemCount:
      //                           context.read<TripProvider>().trips.length,
      //                       itemBuilder: (context, index) {
      //                         final trip =
      //                             context.watch<TripProvider>().trips[index];
      //                         return Card(
      //                           margin: const EdgeInsets.all(10.0),
      //                           color: Theme.of(context).cardColor,
      //                           child: ListTile(
      //                             contentPadding: const EdgeInsets.all(16.0),
      //                             title: Text(
      //                               trip.title,
      //                               style:
      //                                   Theme.of(context).textTheme.titleLarge,
      //                             ),
      //                             subtitle: Text(
      //                               trip.description,
      //                               style:
      //                                   Theme.of(context).textTheme.bodyMedium,
      //                             ),
      //                             onTap: () => context.goNamed('trip',
      //                                 pathParameters: {'tripId': trip.id}),
      //                           ),
      //                         );
      //                       }))
      //             ],
      //           ),
      //         ),
      //       );
      //     })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_trip'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
