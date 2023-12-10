import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traveler/models/models.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  final List<UserInfo> _users = [];
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

  fetchUsers() {
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        print(docSnapshot.data());

        // final reference = FirebaseFirestore.instance
        // .collection('users').doc(docSnapshot.id).withConverter(
        //     fromFirestore: UserInfo.fromFirestore,
        //     toFirestore: (UserInfo user, _) => user.toFirestore());
      }
    });

    // if (user != null) {
    //   _users = users;
    //   notifyListeners();
    // }
  }

  // fetchOne(String id) async {
  //   final reference = FirebaseFirestore.instance
  //       .collection('users').doc(id).withConverter(
  //           fromFirestore: UserInfo.fromFirestore,
  //           toFirestore: (UserInfo user, _) => user.toFirestore());

  //   var docSnap = await reference.get();
  //   final user = docSnap.data();

  //   if (user != null) {
  //     _marker = marker;
  //     notifyListeners();
  //   }
  // }

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
