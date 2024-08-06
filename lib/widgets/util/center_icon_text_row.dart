import 'package:flutter/material.dart';

class CenterRowIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const CenterRowIconText({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
