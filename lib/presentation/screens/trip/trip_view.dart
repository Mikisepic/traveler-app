import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/presentation/screens/trip/trip.dart';
import 'package:traveler/providers/providers.dart';
import 'package:traveler/services/mapbox.service.dart';

class TripViewScreen extends StatefulWidget {
  final String id;

  const TripViewScreen({super.key, required this.id});

  @override
  State<TripViewScreen> createState() => _TripViewScreenState();
}

class _TripViewScreenState extends State<TripViewScreen> {
  List<bool> isOpen = [false, false];
  MapboxService mapboxService = MapboxService();

  @override
  Widget build(BuildContext context) {
    Trip trip = context.read<TripProvider>().trip!;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController titleController =
        TextEditingController(text: trip.title);
    TextEditingController descriptionController =
        TextEditingController(text: trip.description);
    bool? isPrivate;

    List<String> selectedMarkerIds = trip.markers.map((e) => e.id).toList();
    List<String> selectedContributorIds =
        trip.contributors.map((e) => e.id).toList();

    Future<void> fetchMarkerData() async {
      await context.read<TripProvider>().fetchTripMarkers(trip.markers);
    }

    Future<void> fetchContributorData() async {
      await context
          .read<TripProvider>()
          .fetchTripContributors(trip.contributors);
    }

    Widget titleField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
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
              value: isPrivate ?? trip.isPrivate,
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
        initialValue: trip.markers.map((e) => e.id).toList(),
        onConfirm: (values) {
          selectedMarkerIds = values;
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedMarkerIds.remove(value);
            });
          },
        ),
      ),
    );

    Widget optimizeRouteButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          Future<TripOptimization> tripOptimization =
              mapboxService.fetchTripOptimization(
                  'driving',
                  context
                      .read<TripProvider>()
                      .tripMarkers
                      .map((e) => MarkerCoordinates(
                          latitude: e.latitude, longitude: e.longitude))
                      .toList());
          tripOptimization.then((value) {
            context.read<MapProvider>().drawOptimizationPolylines(value);
            print(value.toJson());
          });
        },
        child: const Text('Optimize Route'),
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
        initialValue: trip.contributors.map((e) => e.id).toList(),
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

    Widget expansionPanelList = ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            isOpen[index] = isExpanded;
          });

          if (isOpen[0]) {
            fetchMarkerData();
          }

          if (isOpen[1]) {
            fetchContributorData();
          }
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Markers'),
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                markersField,
                optimizeRouteButton,
              ],
            ),
            isExpanded: isOpen[0],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Contributors'),
              );
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [contributorsField],
            ),
            isExpanded: isOpen[1],
          ),
        ]);

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
                      isPrivate: isPrivate ?? trip.isPrivate,
                      markers: selectedMarkerIds
                          .map((e) =>
                              FirebaseFirestore.instance.doc('markers/$e'))
                          .toList(),
                      contributors: selectedContributorIds
                          .map(
                              (e) => FirebaseFirestore.instance.doc('users/$e'))
                          .toList()),
                );
            context.goNamed('trip_list');
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WrapScaffold(
      appBarLeading: IconButton(
          onPressed: () {
            context
                .read<MapProvider>()
                .initMarkers(context.read<TripProvider>().tripMarkers, false);
            showDialog(
                context: context,
                builder: (BuildContext context) => const Dialog(
                      child: MapScreen(),
                    ));
          },
          icon: const Icon(Icons.map_outlined)),
      appBarActions: [
        IconButton(
            onPressed: () async {
              context.read<TripProvider>().fetchTripNotes(trip.notes);
              if (!mounted) return;
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const SmallDialog(
                        body: TripViewNoteScreen(),
                      ));
            },
            icon: const Icon(Icons.map_outlined))
      ],
      label: trip.title,
      body: Form(
          key: formKey,
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Consumer(builder: (context, provider, child) {
                return ListView(
                  children: <Widget>[
                    titleField,
                    descriptionField,
                    // isPrivateField,
                    expansionPanelList,
                    submitButton
                  ],
                );
              }))),
    );
  }
}
