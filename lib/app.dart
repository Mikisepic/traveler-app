import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/common/common.dart';
import 'package:traveler/presentation/presentation.dart';
import 'package:traveler/providers/providers.dart';

class TravelerApp extends StatelessWidget {
  const TravelerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationProvider()),
          ChangeNotifierProvider(create: (_) => MarkerProvider()),
          ChangeNotifierProvider(create: (_) => TripProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child: MaterialApp.router(
          title: 'Traveller',
          theme: theme,
          routerConfig: router,
        ));
  }
}
