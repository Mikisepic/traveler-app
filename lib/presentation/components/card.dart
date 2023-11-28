import 'package:flutter/material.dart';

Widget buildCard({
  required BuildContext context,
  required String title,
  List<String>? items,
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
            if (items != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map(
                      (item) => Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                    .toList(),
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
