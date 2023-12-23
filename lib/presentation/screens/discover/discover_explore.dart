import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traveler/common/constants.dart';
import 'package:traveler/models/models.dart';
import 'package:traveler/providers/authentication.provider.dart';
import 'package:traveler/providers/marker.provider.dart';

class DiscoverExploreScreen extends StatefulWidget {
  final List<DiscoveryPlace> places;
  final bool loading;

  final Function(List<String> categories, List<String> conditions) onSelected;

  const DiscoverExploreScreen({
    super.key,
    required this.places,
    required this.loading,
    required this.onSelected,
  });

  @override
  State<DiscoverExploreScreen> createState() => _DiscoverExploreScreenState();
}

class _DiscoverExploreScreenState extends State<DiscoverExploreScreen> {
  List<String> _selectedCategories = [];
  final List<String> _selectedConditions = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MultiSelectDialogField<String>(
        items:
            geoapifyPlacesCategories.map((e) => MultiSelectItem(e, e)).toList(),
        initialValue: const [],
        listType: MultiSelectListType.CHIP,
        searchable: true,
        title: const Text('Select Categories'),
        buttonText: const Text('Select at least one category'),
        onConfirm: (values) {
          setState(() {
            _selectedCategories = values;
          });
          widget.onSelected(values, _selectedConditions);
        },
        chipDisplay: MultiSelectChipDisplay(
          items: _selectedCategories.map((e) => MultiSelectItem(e, e)).toList(),
          onTap: (value) {
            setState(() {
              _selectedCategories.remove(value);
            });
            if (_selectedCategories.isNotEmpty) {
              widget.onSelected(_selectedCategories, _selectedConditions);
            }
          },
        ),
      ),
      widget.loading
          ? const CircularProgressIndicator()
          : Expanded(
              child: ListView.builder(
              itemCount: widget.places.length,
              itemBuilder: (context, index) => Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(widget.places[index].properties.name),
                      subtitle: Text(
                          '${widget.places[index].properties.country}, ${widget.places[index].properties.state}, ${widget.places[index].properties.county}, ${widget.places[index].properties.city}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Add Place'),
                          onPressed: () {
                            context.read<MarkerProvider>().create(
                                Marker(
                                    mapboxId: '',
                                    title: widget.places[index].properties.name,
                                    latitude:
                                        widget.places[index].properties.lat,
                                    longitude:
                                        widget.places[index].properties.lon),
                                context
                                    .read<AuthenticationProvider>()
                                    .isAuthenticated);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
    ]);
  }
}
