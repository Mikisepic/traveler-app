import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  cardColor: Colors.orangeAccent,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
    titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    bodyLarge: TextStyle(fontSize: 24),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 12),
  ),
);
