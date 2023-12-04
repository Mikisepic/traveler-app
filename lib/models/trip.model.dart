class Trip {
  final String id;
  final String title;
  final String description;
  final List<dynamic> markers;
  final bool isPrivate;

  Trip({
    required this.id,
    required this.title,
    required this.description,
    this.markers = const [],
    this.isPrivate = false,
  });
}
