import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/constants/constants.dart';
import 'package:traveler/presentation/presentation.dart';
import 'package:traveler/providers/providers.dart';

class TravelerApp extends StatelessWidget {
  const TravelerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (_) => MapProvider()),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
          ChangeNotifierProvider(create: (_) => TripProvider()),
          ChangeNotifierProvider(create: (_) => NoteProvider()),
          ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ],
        child: MaterialApp.router(
          title: 'Traveller',
          theme: theme,
          routerConfig: router,
        ));
  }
}
