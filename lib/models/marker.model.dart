class Marker {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  Marker({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
        id: json['id'] as String,
        title: json['title'] as String,
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double);
  }
}
