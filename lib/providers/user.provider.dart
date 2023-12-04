import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  UserInfo _user = UserInfo(
    id: const Uuid().v4(),
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    trips: [],
    markers: [],
    about:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  );

  UserInfo get user => _user;

  void setUser(UserInfo newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateUserDetails(String newFirstName, String newLastName,
      String newEmail, String newAbout) {
    _user = UserInfo(
        id: _user.id,
        firstName: newFirstName,
        lastName: newLastName,
        email: newEmail,
        trips: _user.trips,
        markers: _user.markers,
        about: newAbout);
    notifyListeners();
  }
}
