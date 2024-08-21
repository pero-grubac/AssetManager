import 'package:asset_manager/providers/census_item_provider.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/census/census_item_card.dart';
import 'package:asset_manager/widgets/util/dismissible_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/census_item.dart';
import '../providers/util_provider.dart';
import '../widgets/util/centered_circular_loading.dart';

class CensusListItemsScreen extends ConsumerStatefulWidget {
  static const id = 'census_list_items_screen';

  const CensusListItemsScreen({super.key});

  @override
  ConsumerState<CensusListItemsScreen> createState() =>
      _CensusListItemsScreenState();
}

class _CensusListItemsScreenState extends ConsumerState<CensusListItemsScreen> {
  late Future<void> _censusItemsFuture;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    final id = ref.watch(censusListIdProvider).toLowerCase();
    _censusItemsFuture = ref.read(censusItemProvider.notifier).loadItems(id);
    super.didChangeDependencies();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  Future<void> _addCensusItem(CensusItem censusItem) async {
    setIsLoading(true);
    await ref.read(censusItemProvider.notifier).addCensusItem(censusItem);
    setIsLoading(false);
  }

  void _showUndoSnackBar(CensusItem censusItem, bool shouldDelete) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (shouldDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Asset deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setIsLoading(true);
              await ref
                  .read(censusItemProvider.notifier)
                  .addCensusItem(censusItem);
              setIsLoading(false);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Asset can not be deleted.'),
      ));
    }
  }

  Future<void> _removeCensusItem(CensusItem censusItem) async {
    await ref.read(censusItemProvider.notifier).removeCensusItem(censusItem);
    _showUndoSnackBar(censusItem, true);
  }

  Future<void> _editCensusItem(CensusItem censusItem) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CensusItemDetails(
          censusItem: censusItem,
          onSaveCensusItem: (censusItem) async {
            await ref
                .read(censusItemProvider.notifier)
                .updateCensusItem(censusItem);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isLoading) const CenteredCircularLoading(),
        Screen(
            body: FutureBuilder(
              future: _censusItemsFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const CenteredCircularLoading()
                      : DismissibleList(
                          onRemoveItem: _removeCensusItem,
                          isEditable: true,
                          onEditItem: _editCensusItem,
                          itemBuilder: (context, censusItem) => CensusItemCard(
                                censusItem: censusItem,
                              ),
                          provider: filteredCensusItemProvider,
                          emptyMessage: 'No items found'),
            ),
            overlay: CensusItemDetails(
              onSaveCensusItem: _addCensusItem,
            ))
      ],
    );
  }
}
