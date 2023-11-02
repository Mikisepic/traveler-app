import 'marker.model.dart';

class Trip {
  final String id;
  final String title;
  final bool isPrivate;
  final String description;
  final List<Marker> markers;

  Trip(
      {required this.id,
      required this.title,
      this.isPrivate = false,
      required this.description,
      required this.markers});
}
