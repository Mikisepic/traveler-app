import 'dart:collection';

import 'package:flutter/material.dart';

import 'marker.dart';

class Trip extends ChangeNotifier {
  final List<Marker> _markers = [];

  UnmodifiableListView<Marker> get locations => UnmodifiableListView(_markers);

  void add(Marker location) {
    _markers.add(location);
    notifyListeners();
  }

  void removeOne(String id) {
    _markers.removeWhere((loc) => loc.id == id);
    notifyListeners();
  }

  void removeAll() {
    _markers.clear();
    notifyListeners();
  }
}
