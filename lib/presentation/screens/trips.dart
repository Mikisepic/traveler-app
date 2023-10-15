import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: LayoutBuilder(builder: (context, constraints) {
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
                            color: Theme.of(context).cardColor,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(
                                'Item $index',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              subtitle: Text(
                                DateTime.now().toUtc().toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onTap: () => context.goNamed('trip',
                                  pathParameters: {'tripId': index.toString()}),
                            ),
                          )),
                ),
              ),
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed('new_trip'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
