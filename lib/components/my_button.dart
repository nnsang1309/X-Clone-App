import 'package:flutter/material.dart';

/*
  A simple button

  --------------------------------------
  To use this widget, you need:

  - Text
  - a function (on tap)

*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          // Color button
          color: Theme.of(context).colorScheme.secondary,
          // Curved corners
          borderRadius: BorderRadius.circular(12),
        ),
        // Text
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
