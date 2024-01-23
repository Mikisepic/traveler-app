import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/providers/providers.dart';

class TripCreateScreen extends StatefulWidget {
  const TripCreateScreen({super.key});

  @override
  State<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends State<TripCreateScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isPrivate = false;
  List<String> selectedMarkerIds = [];
  List<String> selectedContributorIds = [];

  @override
  Widget build(BuildContext context) {
    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: titleController,
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
      ),
    );

    Widget descriptionField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: descriptionController,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Description',
        ),
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
            .read<PlaceProvider>()
            .markers
            .map((e) => MultiSelectItem(e.id, e.title))
            .toList(),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        title: const Text('Select Places'),
        buttonText: const Text('Select places for your trip'),
        onConfirm: (values) {
          selectedMarkerIds = values;
          context.read<MapProvider>().initMarkers(context
              .read<PlaceProvider>()
              .markers
              .where((element) => selectedMarkerIds.contains(element.id))
              .toList());
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedMarkerIds.remove(value);
              context.read<MapProvider>().initMarkers(context
                  .read<PlaceProvider>()
                  .markers
                  .where((element) => selectedMarkerIds.contains(element.id))
                  .toList());
            });
          },
        ),
      ),
    );

    Widget contributorsField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: MultiSelectDialogField<String>(
        items: context
            .read<AuthenticationProvider>()
            .users
            .map((e) => MultiSelectItem(e.id, e.displayName))
            .toList(),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        title: const Text('Select Contributors'),
        buttonText: const Text('Select who will contribute to this trip'),
        onConfirm: (values) {
          selectedContributorIds = values;
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedContributorIds.remove(value);
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
            context.read<TripProvider>().create(
                Trip(
                    title: titleValue,
                    isPrivate: isPrivate,
                    description: descriptionValue,
                    markers: selectedMarkerIds
                        .map(
                            (e) => FirebaseFirestore.instance.doc('markers/$e'))
                        .toList(),
                    contributors: selectedContributorIds
                        .map((e) => FirebaseFirestore.instance.doc('users/$e'))
                        .toList()),
                context.read<AuthenticationProvider>().isAuthenticated);
            context.goNamed('trip_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
        appBarLeading: IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => const Dialog(
                      child: MapScreen(),
                    )),
            icon: const Icon(Icons.map_outlined)),
        label: 'New Trip',
        body: Form(
          key: formKey,
          child: Padding(
              padding: const EdgeInsets.all(40),
              child: ListView(
                children: <Widget>[
                  titleField,
                  descriptionField,
                  isPrivateField,
                  markersField,
                  contributorsField,
                  submitButton,
                ],
              )),
        ));
  }
}
