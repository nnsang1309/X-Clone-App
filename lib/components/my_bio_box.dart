import 'package:flutter/material.dart';

/*
  USER BIO BOX

  To use this widget, you just need:

  - text
*/

class MyBioBox extends StatelessWidget {
  final String text;

  const MyBioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // Container
    return Container(
      decoration: BoxDecoration(
        //color
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),

      //padding inside
      padding: EdgeInsets.all(25),

      child: Text(
        text.isNotEmpty ? text : "Empty bio...",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
