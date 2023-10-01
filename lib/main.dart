import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveler/screens/screens.dart';

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

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyTrips = GlobalKey<NavigatorState>();
final _shellNavigatorKeyMap = GlobalKey<NavigatorState>();
final _shellNavigatorKeyProfile = GlobalKey<NavigatorState>();

final _router = GoRouter(
  initialLocation: '/map',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(navigatorKey: _shellNavigatorKeyTrips, routes: [
            GoRoute(
                path: '/trips',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TripsScreen()),
                routes: [
                  GoRoute(
                    name: 'trip',
                    path: 'trips/:tripId',
                    builder: (context, state) =>
                        TripsScreen(id: state.pathParameters['tripId']),
                  ),
                ]),
          ]),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyMap,
            routes: [
              GoRoute(
                path: '/map',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MapScreen()),
              ),
            ],
          ),
          StatefulShellBranch(navigatorKey: _shellNavigatorKeyProfile, routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ]),
        ]),
  ],
);
