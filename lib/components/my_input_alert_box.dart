import 'package:flutter/material.dart';

/*
  This use this widget

  - text controller (accces what the user type)     
  - hint text 
  - a function
  - text for button 
*/

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Curve corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),

      // Color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Textfield (user type here)
      content: TextField(
        controller: textController,

        // limit chacracters
        maxLength: 140,
        maxLines: 3,

        decoration: InputDecoration(
          // border when textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          //border when textfiel is selected
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),

          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          // Color inside of textfield
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          // cpunter style
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),

      // Buttons
      actions: [
        // cannel button
        TextButton(
          onPressed: () {
            // close box
            Navigator.pop(context);

            // clear controller
            textController.clear();
          },
          child: const Text("Cannel"),
        ),

        // yes button
        TextButton(
          onPressed: () {
            // close box
            Navigator.pop(context);

            // execute function
            onPressed!();

            // clear controller
            textController.clear();
          },
          child: Text(onPressedText),
        ),
      ],
    );
  }
}
