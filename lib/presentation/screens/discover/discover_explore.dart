import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:traveler/common/constants.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/presentation/components/search.dart';

class DiscoverExploreScreen extends StatefulWidget {
  final List<DiscoveryPlace> places;
  final Function(MarkerRetrieval mapboxMarker, List<String> categoies,
      List<String> conditions) onSelected;

  const DiscoverExploreScreen({
    super.key,
    required this.places,
    required this.onSelected,
  });

  @override
  State<DiscoverExploreScreen> createState() => _DiscoverExploreScreenState();
}

class _DiscoverExploreScreenState extends State<DiscoverExploreScreen> {
  MarkerRetrieval? selectedMapboxMarker;
  List<String> selectedCategories = ['activity'];
  List<String> selectedConditions = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Search(
          initialValue: '',
          onSearchComplete: (mapboxMarker) {
            widget.onSelected(
                mapboxMarker, selectedCategories, selectedConditions);
          },
        ),
        MultiSelectDialogField<String>(
          items: geoapifyPlacesCategories
              .map((e) => MultiSelectItem(e, e))
              .toList(),
          initialValue: selectedCategories,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          onConfirm: (values) {
            setState(() {
              selectedCategories = values;
            });
            widget.onSelected(selectedMapboxMarker as MarkerRetrieval,
                selectedCategories, selectedConditions);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                selectedCategories.remove(value);
              });
              widget.onSelected(selectedMapboxMarker as MarkerRetrieval,
                  selectedCategories, selectedConditions);
            },
          ),
        ),
      ],
    );
  }
}
