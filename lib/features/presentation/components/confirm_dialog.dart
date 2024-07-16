import 'package:flutter/material.dart';

//dialog to confirm
class ConfirmDialogue extends StatelessWidget {
  final String text;
  final VoidCallback function;

  const ConfirmDialogue({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      content: Text("Are you sure you want to $text?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: function,
          child: Text("OK"),
        ),
      ],
    );
  }
}
