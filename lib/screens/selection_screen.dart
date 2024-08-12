import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/identifiable.dart';

class SelectionScreen<T extends Identifiable> extends ConsumerStatefulWidget {
  const SelectionScreen({
    super.key,
    required this.provider,
    required this.onConfirmSelection,
    required this.cardBuilder,
    required this.title,
    required this.emptyMessage,
  });

  final StateNotifierProvider<dynamic, List<T>> provider;
  final void Function(T selectedItem) onConfirmSelection;
  final Widget Function(T item, bool isSelected, VoidCallback onTap)
      cardBuilder;
  final String title;
  final String emptyMessage;

  @override
  ConsumerState<SelectionScreen<T>> createState() => _SelectionScreenState<T>();
}

class _SelectionScreenState<T extends Identifiable>
    extends ConsumerState<SelectionScreen<T>> {
  String? _selectedItemId;
  late Future<void> _loadItemsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load the items asynchronously
    _loadItemsFuture = ref.read(widget.provider.notifier).loadItems();
  }

  void _selectItem(String itemId) {
    setState(() {
      _selectedItemId = itemId;
    });
  }

  void _confirmSelection() {
    final items = ref.read(widget.provider);
    final selectedItem = items.firstWhere(
      (item) => item.id == _selectedItemId,
    );
    Navigator.pop(context, selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadItemsFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    title: Text(widget.title),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed:
                            _selectedItemId == null ? null : _confirmSelection,
                      ),
                    ],
                  ),
                  body: Consumer(
                    builder: (context, ref, child) {
                      final items = ref.watch(widget.provider);
                      if (items == null || items.isEmpty) {
                        return Center(
                          child: Text(widget.emptyMessage),
                        );
                      }
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (ctx, index) {
                          final item = items[index];
                          final isSelected = item.id == _selectedItemId;

                          return widget.cardBuilder(
                            item,
                            isSelected,
                            () => _selectItem(item.id),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
