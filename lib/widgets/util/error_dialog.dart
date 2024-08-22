import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    // The ErrorDialog should not itself call showDialog, but return the widget
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.invalidInput),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.okay),
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
