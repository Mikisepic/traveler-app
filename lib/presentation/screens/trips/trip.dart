import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/presentation/components/wrap.dart';
import 'package:traveler/providers/providers.dart';

class TripDetailsScreen extends StatefulWidget {
  final String id;

  const TripDetailsScreen({super.key, required this.id});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final trip = context.read<TripProvider>().trips[context
        .read<TripProvider>()
        .trips
        .indexWhere((element) => element.id == widget.id)];
    final titleController = TextEditingController(text: trip.title);

    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          )),
        ],
      ),
    );

    return WrapScaffold(
      label: widget.id,
      body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: <Widget>[titleField],
          )),
    );
  }
}
