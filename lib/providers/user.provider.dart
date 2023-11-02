import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';

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
