import 'dart:ffi';

import 'package:flutter/material.dart';

class DismissibleList<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T item) onRemoveItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final void Function(T item)? onEditItem;
  final bool isEditable;

  const DismissibleList({
    super.key,
    required this.items,
    required this.onRemoveItem,
    required this.isEditable,
    this.onEditItem,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey(item),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              onRemoveItem(item);
            } else if (direction == DismissDirection.endToStart) {
              if (isEditable && onEditItem != null) {
                onEditItem!(item);
              }
            }
          },
          direction: isEditable
              ? DismissDirection.horizontal
              : DismissDirection.startToEnd,
          background: Container(
            color: Theme.of(context).colorScheme.error,
            margin: Theme.of(context).cardTheme.margin,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Theme.of(context).colorScheme.primary,
            margin: Theme.of(context).cardTheme.margin,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          child: itemBuilder(context, item),
        );
      },
    );
  }
}
