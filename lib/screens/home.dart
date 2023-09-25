import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveller'),
      ),
      body: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              child: const Icon(Icons.directions),
              onPressed: () => context.goNamed('profile')),
          TextButton(
              child: const Icon(Icons.map),
              onPressed: () => context.goNamed('map')),
          TextButton(
              child: const Icon(Icons.person),
              onPressed: () => context.goNamed('profile')),
        ],
      ),
    );
  }
}
