import 'package:flutter/material.dart';

class DismissibleList<T> extends StatelessWidget {
  final List<T> items;
  final void Function(T item) onRemoveItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String Function(T item) itemKey;

  const DismissibleList({
    super.key,
    required this.items,
    required this.onRemoveItem,
    required this.itemBuilder,
    required this.itemKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: ValueKey(itemKey(item)),
          onDismissed: (direction) {
            onRemoveItem(item);
          },
          direction: DismissDirection.startToEnd,
          background: Container(
            color: Theme.of(context).colorScheme.error,
            margin: Theme.of(context).cardTheme.margin,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: itemBuilder(context, item),
        );
      },
    );
  }
}
