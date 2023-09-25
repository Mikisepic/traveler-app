import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveler/screens/screens.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          name: 'map',
          path: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: 'trips',
          path: '/trips',
          builder: (context, state) => const TripsScreen(),
        ),
        GoRoute(
          name: 'trip',
          path: '/trips/:tripId',
          builder: (context, state) =>
              TripsScreen(id: state.pathParameters['tripId']),
        ),
      ],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return const HomeScreen();
      },
    )
  ],
);

void main() {
  runApp(const TravelerApp());
}

class TravelerApp extends StatelessWidget {
  const TravelerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Traveller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
