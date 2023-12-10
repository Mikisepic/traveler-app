import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
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
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Trip trip = context.read<TripProvider>().fetchDialogData(widget.id);
    TextEditingController titleController =
        TextEditingController(text: trip.title);
    TextEditingController descriptionController =
        TextEditingController(text: trip.description);
    bool isPrivate = trip.isPrivate;
    List<String> selectedMarkers = [];
    List<String> selectedContributors = [];

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

    Widget descriptionField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: descriptionController,
            autofocus: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Title',
            ),
          )),
        ],
      ),
    );

    Widget isPrivateField = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('Is Private'),
            Switch(
              value: isPrivate,
              onChanged: (bool value) {
                setState(() {
                  isPrivate = value;
                });
              },
            )
          ],
        ));

    Widget markersField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: MultiSelectDialogField<String>(
        items: context
            .read<MarkerProvider>()
            .markers
            .map((e) => MultiSelectItem(e.id, e.title))
            .toList(),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        initialValue: trip.markers,
        onConfirm: (values) {
          selectedMarkers = values;
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedMarkers.remove(value);
            });
          },
        ),
      ),
    );

    Widget submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final titleValue = titleController.text;
            final descriptionValue = descriptionController.text;
            context.read<TripProvider>().update(
                  Trip(
                      id: widget.id,
                      title: titleValue,
                      description: descriptionValue,
                      isPrivate: isPrivate,
                      markers: selectedMarkers,
                      contributors: selectedContributors),
                );
            context.goNamed('trip_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
      label: trip.title,
      body: Form(
          key: formKey,
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: ListView(
                children: <Widget>[
                  titleField,
                  descriptionField,
                  isPrivateField,
                  markersField,
                  submitButton
                ],
              ))),
    );
  }
}
