import 'package:flutter/material.dart';

class RowIconWidget extends StatelessWidget {
  final IconData icon;
  final Widget widget;

  const RowIconWidget({
    super.key,
    required this.icon,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        widget,
      ],
    );
  }
}
