import 'package:flutter/material.dart';

class WrapScaffold extends StatelessWidget {
  const WrapScaffold({
    super.key,
    required this.label,
    required this.body,
    this.bottomAppBar,
    this.floatingActionButton,
    this.detailsPath,
  });

  final String label;
  final Widget body;
  final PreferredSizeWidget? bottomAppBar;
  final Widget? floatingActionButton;
  final String? detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(label),
        bottom: bottomAppBar,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
