import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:traveler/models/marker.model.dart';
import 'package:traveler/presentation/components/components.dart';

class DiscoverRecommendedScreen extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(MarkerRetrieval mapboxMarker) onMarkerSelected;
  final Function(List<String> categoryList) onCategoriesSelect;
  final Function(String category) onCategoryRemove;

  const DiscoverRecommendedScreen({
    super.key,
    required this.selectedCategories,
    required this.onMarkerSelected,
    required this.onCategoriesSelect,
    required this.onCategoryRemove,
  });

  @override
  State<DiscoverRecommendedScreen> createState() =>
      _DiscoverRecommendedScreenState();
}

class _DiscoverRecommendedScreenState extends State<DiscoverRecommendedScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Search(
          initialValue: '',
          onSearchComplete: (mapboxMarker) {
            widget.onMarkerSelected(mapboxMarker);
          },
        ),
        MultiSelectDialogField<String>(
          items: const [],
          initialValue: widget.selectedCategories,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          onConfirm: (values) {
            widget.onCategoriesSelect(values);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              widget.onCategoryRemove(value);
            },
          ),
        ),
      ],
    );
  }
}
