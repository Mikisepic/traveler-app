import 'marker.model.dart';

class Trip {
  final String id;
  final String title;
  final String description;
  final List<MapboxMarker> markers;
  final bool isPrivate;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    this.markers = const [],
    this.isPrivate = false,
  });
}
