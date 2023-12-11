import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('HomeScreen'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ScaffoldWithNavigationBar(
        body: navigationShell,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(label: 'Trips', icon: Icon(Icons.directions)),
          BottomNavigationBarItem(label: 'Map', icon: Icon(Icons.map)),
          BottomNavigationBarItem(label: 'Explore', icon: Icon(Icons.explore)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
        onTap: onDestinationSelected,
      ),
    );
  }
}
