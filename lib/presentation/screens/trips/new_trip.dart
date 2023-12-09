import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/providers/providers.dart';
import 'package:uuid/uuid.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isPrivate = false;
  List<Marker> _selectedMarkers = [];

  @override
  Widget build(BuildContext context) {
    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
      child: MultiSelectDialogField<Marker>(
        items: context
            .read<MarkerProvider>()
            .markers
            .map((e) => MultiSelectItem(e, e.title))
            .toList(),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        onConfirm: (values) {
          _selectedMarkers = values;
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              _selectedMarkers.remove(value);
            });
          },
        ),
      ),
    );

    Widget contributorsField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: MultiSelectDialogField<Marker>(
        items: context
            .read<MarkerProvider>()
            .markers
            .map((e) => MultiSelectItem(e, e.title))
            .toList(),
        listType: MultiSelectListType.CHIP,
        searchable: true,
        onConfirm: (values) {
          _selectedMarkers = values;
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              _selectedMarkers.remove(value);
            });
          },
        ),
      ),
    );

    Widget submitButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final titleValue = titleController.text;
            final descriptionValue = descriptionController.text;
            context.read<TripProvider>().create(
                Trip(
                    id: const Uuid().v4(),
                    title: titleValue,
                    isPrivate: isPrivate,
                    description: descriptionValue,
                    markers: _selectedMarkers),
                context.read<AuthenticationProvider>().isAuthenticated);
            context.goNamed('trip_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
        label: 'New Trip',
        body: Form(
          key: _formKey,
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
