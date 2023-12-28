import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveler/presentation/screens/discover/discover.dart';
import 'package:traveler/presentation/screens/place/place.dart';
import 'package:traveler/presentation/screens/profile/profile.dart';
import 'package:traveler/presentation/screens/screens.dart';
import 'package:traveler/presentation/screens/trip/trip.dart';
import 'package:traveler/providers/providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKeyTrips = GlobalKey<NavigatorState>();
final _shellNavigatorKeyMap = GlobalKey<NavigatorState>();
final _shellNavigatorKeyDiscover = GlobalKey<NavigatorState>();
final _shellNavigatorKeyProfile = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/places',
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
                name: 'trip_list',
                path: '/trips',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TripListScreen()),
                routes: [
                  GoRoute(
                      name: 'new_trip',
                      path: 'trips/new',
                      builder: (context, state) => const TripCreateScreen()),
                  GoRoute(
                    name: 'trip',
                    path: 'trips/:tripId',
                    builder: (context, state) =>
                        TripViewScreen(id: state.pathParameters['tripId']!),
                  ),
                ]),
          ]),
          StatefulShellBranch(
              navigatorKey: _shellNavigatorKeyDiscover,
              routes: [
                GoRoute(
                    name: 'discover_list',
                    path: '/discover_list',
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ExploreListScreen()),
                    routes: const []),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKeyMap,
            routes: [
              GoRoute(
                  name: 'place_list',
                  path: '/places',
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: PlaceListScreen()),
                  routes: [
                    GoRoute(
                      name: 'new_place',
                      path: 'places/new',
                      builder: (context, state) => const PlaceCreateScreen(),
                    )
                  ]),
            ],
          ),
          StatefulShellBranch(navigatorKey: _shellNavigatorKeyProfile, routes: [
            GoRoute(
              name: 'user_info',
              path: '/user_info',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileViewScreen()),
            ),
          ]),
        ]),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return SignInScreen(
          providers: [
            EmailAuthProvider(),
          ],
          actions: [
            ForgotPasswordAction(((context, email) {
              final uri = Uri(
                path: 'sign-in/forgot-password',
                queryParameters: <String, String?>{
                  'email': email,
                },
              );
              context.push(uri.toString());
            })),
            AuthStateChangeAction(((context, state) {
              final user = switch (state) {
                SignedIn state => state.user,
                UserCreated state => state.credential.user,
                _ => null
              };
              if (user == null) {
                return;
              }
              if (state is UserCreated) {
                var shortName = user.email!.split('@')[0];
                user.updateDisplayName(shortName);
                context
                    .read<AuthenticationProvider>()
                    .registerUserInFirestore(user.uid, user.email, shortName);
              }
              if (!user.emailVerified) {
                user.sendEmailVerification();
                const snackBar = SnackBar(
                    content: Text(
                        'Please check your email to verify your email address'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              context.goNamed('user_info');
            })),
          ],
        );
      },
      routes: [
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.goNamed('user_info');
            }),
          ],
        );
      },
    ),
  ],
);
