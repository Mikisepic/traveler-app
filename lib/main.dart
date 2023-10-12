import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:traveler/common/styles.dart';
import 'package:traveler/presentation/presentation.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const TravelerApp());
}

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
