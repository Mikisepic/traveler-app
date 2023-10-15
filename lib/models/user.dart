import 'marker.dart';
import 'trip.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final List<Trip> trips;
  final List<Marker> markers;
  final String about;

  User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.trips,
      required this.markers,
      required this.about});
}
