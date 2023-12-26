import 'package:flutter/material.dart';

class WrapScaffold extends StatelessWidget {
  const WrapScaffold({
    super.key,
    required this.label,
    required this.body,
    this.appBarLeading,
    this.appBarBottom,
    this.floatingActionButton,
    this.detailsPath,
  });

  final String label;
  final Widget body;
  final Widget? appBarLeading;
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
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
