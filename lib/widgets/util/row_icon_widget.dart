import 'package:asset_manager/widgets/util/helper_widgets.dart';
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
        addHorizontalSpace(8),
        widget,
      ],
    );
  }
}
