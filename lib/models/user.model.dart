import 'marker.model.dart';
import 'trip.model.dart';

class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String about;
  final List<Trip> trips;
  final List<MarkerRetrieval> markers;

  UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.about,
    required this.trips,
    required this.markers,
  });
}
