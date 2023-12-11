import 'package:flutter/material.dart';
import 'package:traveler/presentation/components/components.dart';

class ExploreListScreen extends StatefulWidget {
  const ExploreListScreen({super.key});

  @override
  State<ExploreListScreen> createState() => _ExploreListScreenState();
}

class _ExploreListScreenState extends State<ExploreListScreen> {
  @override
  Widget build(BuildContext context) {
    return const WrapScaffold(label: 'Explore', body: Placeholder());
  }
}
