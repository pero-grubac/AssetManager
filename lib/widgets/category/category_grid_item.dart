import 'package:asset_manager/models/category/category.dart';
import 'package:flutter/material.dart';

import '../../theme/box_decoration_theme.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onTap,
  });
  final Category category;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final boxDecoration =
        Theme.of(context).extension<CustomBoxDecorationTheme>()?.boxDecoration;

    return InkWell(
      onTap: onTap,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: boxDecoration,
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}
