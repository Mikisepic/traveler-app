import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './screens/screens.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyTrips = GlobalKey<NavigatorState>();
final _shellNavigatorKeyMap = GlobalKey<NavigatorState>();
final _shellNavigatorKeyProfile = GlobalKey<NavigatorState>();

final router = GoRouter(
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
                        TripDetailsScreen(id: state.pathParameters['tripId']!),
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
              pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(
                firstName: 'John',
                lastName: 'Doe',
                email: 'john.doe@example.com',
                trips: ['Trip 1', 'Trip 2'],
                addedLocations: ['Location A', 'Location B'],
                about:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              )),
            ),
          ]),
        ]),
  ],
);
