import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DismissibleList<T> extends ConsumerWidget {
  final Future<void> Function(T item) onRemoveItem;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function(T item)? onEditItem;
  final bool isEditable;
  final Provider<List<T>> provider;
  final String emptyMessage;

  const DismissibleList({
    super.key,
    required this.onRemoveItem,
    required this.isEditable,
    this.onEditItem,
    required this.itemBuilder,
    required this.provider,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(provider);
    Widget mainContent = Center(
      child: Text(emptyMessage),
    );
    if (items.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: ValueKey(item),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                return true;
              } else if (direction == DismissDirection.endToStart) {
                if (isEditable && onEditItem != null) {
                  onEditItem!(item);
                }
                return false;
              }
              return false;
            },
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                await onRemoveItem(item);
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
    return mainContent;
  }
}
