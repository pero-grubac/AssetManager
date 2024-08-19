import 'package:asset_manager/providers/census_list_provider.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/census/census_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/census_list.dart';
import '../widgets/census/census_list_overlay.dart';
import '../widgets/util/centered_circular_loading.dart';
import '../widgets/util/dismissible_list.dart';

class CensusListScreen extends ConsumerStatefulWidget {
  static const id = 'census_screen';

  const CensusListScreen({super.key});

  @override
  ConsumerState<CensusListScreen> createState() => _CensusListScreenState();
}

class _CensusListScreenState extends ConsumerState<CensusListScreen> {
  final _searchController = TextEditingController();
  late Future<void> _censusListFuture;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _initializeAssets();
  }

  void _initializeAssets() async {
    _censusListFuture = ref.read(censusListProvider.notifier).loadItems();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchCensusList(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

//TODO
  Future<void> _removeCensusList(CensusList censusList) async {
    final censusListNotifier = ref.read(censusListProvider.notifier);
    final censusListIndex = censusListNotifier.indexOfCensusList(censusList);
    final updatedState =
        censusListNotifier.state.where((cl) => cl.id != censusList.id).toList();
    censusListNotifier.state = updatedState;
    final shouldDelete = await censusListNotifier.removeCensusList(censusList);
    if (!shouldDelete) {
      censusListNotifier.state = [
        ...updatedState.sublist(0, censusListIndex),
        censusList,
        ...updatedState.sublist(censusListIndex),
      ];
    }
    _showUndoSnackBar(censusList, censusListIndex, shouldDelete);
  }

  void _showUndoSnackBar(
      CensusList censusList, int censusListIndex, bool shouldDelete) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (shouldDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Census List deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setIsLoading(true);
              await ref
                  .read(censusListProvider.notifier)
                  .insertCensusList(censusList, censusListIndex);
              setIsLoading(false);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Worker can not be deleted.'),
      ));
    }
  }

  Future<void> _editCensusList(CensusList censusList) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => CensusListOverlay(
        onSave: (censusList) async {
          setIsLoading(true);
          await ref
              .read(censusListProvider.notifier)
              .updateCensusList(censusList);
          setIsLoading(false);
        },
        censusList: censusList,
      ),
    );
  }

  Future<void> _addCensusList(CensusList censusList) async {
    setIsLoading(true);
    await ref.read(censusListProvider.notifier).addCensusList(censusList);
    setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isLoading) const CenteredCircularLoading(),
        Screen(
          searchController: _searchController,
          onSearchChanged: _searchCensusList,
          body: FutureBuilder(
            future: _censusListFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const CenteredCircularLoading()
                    : DismissibleList(
                        onRemoveItem: _removeCensusList,
                        onEditItem: _editCensusList,
                        isEditable: true,
                        itemBuilder: (context, censusList) =>
                            CensusListCard(censusList: censusList),
                        provider: filteredCensusListProvider,
                        emptyMessage: 'No census list found'),
          ),
          overlay: CensusListOverlay(
            onSave: _addCensusList,
          ),
        )
      ],
    );
  }
}
