import 'package:flutter/material.dart';

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

class UserProvider extends ChangeNotifier {
  User _user = User(
      firstName: '',
      lastName: '',
      email: '',
      trips: [],
      markers: [],
      about: '');

  User get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateUserDetails(String newFirstName, String newLastName,
      String newEmail, String newAbout) {
    _user = User(
        firstName: newFirstName,
        lastName: newLastName,
        email: newEmail,
        trips: _user.trips,
        markers: _user.markers,
        about: newAbout);
    notifyListeners();
  }
}
