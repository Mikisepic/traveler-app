import 'package:flutter/material.dart';
import 'package:traveler/common/common.dart';
import 'package:traveler/presentation/presentation.dart';

class TravelerApp extends StatelessWidget {
  const TravelerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Traveller',
      theme: theme,
      routerConfig: router,
    );
  }
}