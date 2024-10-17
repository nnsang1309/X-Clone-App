import 'package:flutter/material.dart';

/*
  SETTING LIST TILE

  This i am simple tile for each item in the settings page.

  -----
  To use this widget, you need:

  - title ( e.g. "Dark mode")
  - action ( e.g. toggleTheme() )
*/

class MySettingsTile extends StatelessWidget {
  final String title;
  final Widget action;

  const MySettingsTile({
    super.key,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          // Curve corners
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            action,
          ],
        ));
  }
}
