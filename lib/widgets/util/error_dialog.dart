import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    // The ErrorDialog should not itself call showDialog, but return the widget
    return AlertDialog(
      title: const Text('Invalid input'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }

  // Static method to show the dialog easily from anywhere
  static Future<void> show(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message: message),
    );
  }
}
