import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:flutter/material.dart';

class CenterRowIconText extends StatelessWidget {
  final IconData icon;
  final Widget widget;

  const CenterRowIconText({
    super.key,
    required this.icon,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        addHorizontalSpace(8),
        widget,
      ],
    );
  }
}
