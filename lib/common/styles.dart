import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  cardColor: Colors.orangeAccent,
  textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
);
