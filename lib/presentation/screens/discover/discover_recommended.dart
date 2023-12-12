import 'package:flutter/material.dart';

class DiscoverRecommendedScreen extends StatefulWidget {
  final List<String> categories;

  const DiscoverRecommendedScreen({super.key, required this.categories});

  @override
  State<DiscoverRecommendedScreen> createState() =>
      _DiscoverRecommendedScreenState();
}

class _DiscoverRecommendedScreenState extends State<DiscoverRecommendedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("It's rainy here"),
    );
  }
}
