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
                          child: SizedBox(
                            height: 100,
                            child: Center(child: Text('Item $index')),
                          ),
                        )),
              ),
            ),
          );
        }));
  }
}
