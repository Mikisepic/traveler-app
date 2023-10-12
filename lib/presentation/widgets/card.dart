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
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (items != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map(
                      (item) => Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                    .toList(),
              ),
            if (content != null)
              Text(
                content,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
