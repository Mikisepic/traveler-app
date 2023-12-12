import 'package:flutter/material.dart';
import 'package:traveler/presentation/components/components.dart';
import 'package:traveler/presentation/screens/discover/discover_explore.dart';
import 'package:traveler/presentation/screens/discover/discover_recommended.dart';

class ExploreListScreen extends StatefulWidget {
  const ExploreListScreen({super.key});

  @override
  State<ExploreListScreen> createState() => _ExploreListScreenState();
}

class _ExploreListScreenState extends State<ExploreListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WrapScaffold(
      label: 'Discover',
      bottomAppBar: TabBar(controller: _tabController, tabs: const <Widget>[
        Tab(
          icon: Icon(Icons.person),
          text: 'For me',
        ),
        Tab(
          icon: Icon(Icons.search),
          text: 'Explore',
        ),
      ]),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          DiscoverExploreScreen(),
          DiscoverRecommendedScreen()
        ],
      ),
    );
  }
}
