import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:traveler/common/constants.dart';
import 'package:traveler/models/discovery.model.dart';
import 'package:traveler/models/marker.model.dart';
import 'package:traveler/presentation/components/components.dart';

class DiscoverRecommendedScreen extends StatefulWidget {
  final List<DiscoveryPlace> places;
  final Function(MarkerRetrieval mapboxMarker, List<String> categoies,
      List<String> conditions) onSelected;

  const DiscoverRecommendedScreen({
    super.key,
    required this.places,
    required this.onSelected,
  });

  @override
  State<DiscoverRecommendedScreen> createState() =>
      _DiscoverRecommendedScreenState();
}

class _DiscoverRecommendedScreenState extends State<DiscoverRecommendedScreen> {
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
