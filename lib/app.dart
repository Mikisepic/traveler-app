import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveler/common/common.dart';
import 'package:traveler/presentation/presentation.dart';
import 'package:traveler/providers/providers.dart';

class TravelerApp extends StatelessWidget {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TravelerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => AuthenticationProvider(
                  firebaseAuth: firebaseAuth,
                  firebaseFirestore: firebaseFirestore)),
          ChangeNotifierProvider(
              create: (_) => MarkerProvider(
                  firebaseFirestore: firebaseFirestore,
                  firebaseAuth: firebaseAuth)),
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
