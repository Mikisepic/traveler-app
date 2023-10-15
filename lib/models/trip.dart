import 'dart:collection';

import 'package:flutter/material.dart';

import 'location.dart';

class Trip extends ChangeNotifier {
  final List<Location> _locations = [];

  UnmodifiableListView<Location> get locations =>
      UnmodifiableListView(_locations);

  void add(Location location) {
    _locations.add(location);
    notifyListeners();
  }

  void removeOne(String id) {
    _locations.removeWhere((loc) => loc.id == id);
    notifyListeners();
  }

  void removeAll() {
    _locations.clear();
    notifyListeners();
  }
}
