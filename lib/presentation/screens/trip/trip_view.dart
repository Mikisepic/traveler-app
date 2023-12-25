import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/wrap.dart';
import 'package:traveler/providers/providers.dart';
import 'package:traveler/services/mapbox.service.dart';

class Item {
  Item({
    required this.expandedBody,
    required this.headerValue,
    // required this.expandedCallback,
    this.isExpanded = false,
  });

  Widget expandedBody;
  String headerValue;
  bool isExpanded;
  // Function() expandedCallback;
}

class TripViewScreen extends StatefulWidget {
  final String id;

  const TripViewScreen({super.key, required this.id});

  @override
  State<TripViewScreen> createState() => _TripViewScreenState();
}

class _TripViewScreenState extends State<TripViewScreen> {
  List<bool> isOpen = [false, false];

  @override
  Widget build(BuildContext context) {
    final MapboxService mapboxService = MapboxService();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Trip trip = context.read<TripProvider>().fetchDialogData(widget.id);
    TextEditingController titleController =
        TextEditingController(text: trip.title);
    TextEditingController descriptionController =
        TextEditingController(text: trip.description);
    bool isPrivate = trip.isPrivate;
    List<String> selectedMarkerIds = [];
    List<Marker> selectedMarkers = [];
    List<UserProfileMetadata> selectedContributors = [];
    bool loading = false;

    @override
    void initState() {
      super.initState();
    }

    Future<void> fetchMarkerData() async {
      setState(() {
        loading = true;
        selectedMarkerIds = [];
      });
      final tripMarkers =
          context.read<TripProvider>().fetchTripMarkerData(trip.markers);
      setState(() {
        selectedMarkers = tripMarkers;
        selectedMarkerIds = selectedMarkers.map((e) => e.id).toList();
        loading = false;
      });
    }

    Future<void> fetchContributorData() async {
      for (final contributor in trip.contributors) {
        print(contributor);
      }
    }

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
        searchHint: 'Add Places',
        initialValue: trip.markers.map((e) => e.id).toList(),
        onConfirm: (values) {
          selectedMarkerIds = values;
          selectedMarkers = context
              .read<MarkerProvider>()
              .markers
              .where((element) => selectedMarkerIds.contains(element.id))
              .toList();
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
            setState(() {
              selectedMarkerIds.remove(value);
              selectedMarkers = context
                  .read<MarkerProvider>()
                  .markers
                  .where((element) => selectedMarkerIds.contains(element.id))
                  .toList();
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
                  selectedMarkers
                      .map((e) => MarkerCoordinates(
                          latitude: e.latitude, longitude: e.longitude))
                      .toList());
          tripOptimization.then((value) => print(value.toJson()));
        },
        child: const Text('Optimize Route'),
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
                title:
                    Text('Markers'), // You can customize the header as needed
              );
            },
            body: loading
                ? const CircularProgressIndicator()
                : Column(
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
                title: Text(
                    'Contributors'), // You can customize the header as needed
              );
            },
            body: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add your expansion panel content here
                // For example, you can add a list of markers or any other widgets
              ],
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
                      isPrivate: isPrivate,
                      markers: selectedMarkers
                          .map((e) =>
                              FirebaseFirestore.instance.doc('markers/$e'))
                          .toList(),
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
                  expansionPanelList,
                  submitButton
                ],
              ))),
    );
  }
}
