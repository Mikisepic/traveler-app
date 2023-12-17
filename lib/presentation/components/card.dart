import 'package:flutter/material.dart';

Widget buildCard({
  required BuildContext context,
  required String title,
  String? content,
}) {
  return Expanded(
    child: Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (content != null)
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    ),
  );
}
