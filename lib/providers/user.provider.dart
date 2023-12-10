import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  List<UserInfo> _users = [];
  List<UserInfo> get users => _users;

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

  Future<UserInfo> doStuff(String id) async {
    final reference = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .withConverter(
            fromFirestore: UserInfo.fromFirestore,
            toFirestore: (UserInfo user, _) => user.toFirestore());

    var docSnap = await reference.get();
    return docSnap.data()!;
  }

  fetchUsers() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<UserInfo> usrs = [];

    await Future.wait(
      querySnapshot.docs.map((docSnapshot) async {
        var value = await doStuff(docSnapshot.id);
        usrs.add(value);
      }),
    );
    _users = usrs;
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
