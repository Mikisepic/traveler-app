import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:traveler/presentation/components/components.dart';

class DiscoverRecommendedScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const DiscoverRecommendedScreen(
      {super.key, required this.selectedCategories});

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
            print(mapboxMarker);
          },
        ),
        MultiSelectDialogField<String>(
          items: const [],
          initialValue: widget.selectedCategories,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          onConfirm: (values) {
            print(values);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              print(value);
              // setState(() {
              //   selectedMarkers.remove(value);
              // });
            },
          ),
        ),
      ],
    );
  }
}
