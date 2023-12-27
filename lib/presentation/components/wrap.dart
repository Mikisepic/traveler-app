import 'package:flutter/material.dart';

class WrapScaffold extends StatelessWidget {
  const WrapScaffold({
    super.key,
    required this.label,
    required this.body,
    this.appBarLeading,
    this.appBarActions,
    this.appBarBottom,
    this.floatingActionButton,
    this.detailsPath,
  });

  final String label;
  final Widget body;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final PreferredSizeWidget? appBarBottom;
  final Widget? floatingActionButton;
  final String? detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(label),
        bottom: appBarBottom,
        actions: appBarActions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
