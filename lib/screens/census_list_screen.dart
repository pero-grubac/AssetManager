import 'package:asset_manager/providers/census_list_provider.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/census/census_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void didChangeDependencies() {
    _censusListFuture = ref.read(censusListProvider.notifier).loadItems();
    super.didChangeDependencies();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchCensusList(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _removeCensusList(CensusList censusList) async {
    final censusListNotifier = ref.read(censusListProvider.notifier);
    final shouldDelete = await censusListNotifier.removeCensusList(censusList);
    _showUndoSnackBar(censusList, shouldDelete);
  }

  void _showUndoSnackBar(CensusList censusList, bool shouldDelete) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (shouldDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(AppLocalizations.of(context)!.censusListDelete),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.undo,
            onPressed: () async {
              setIsLoading(true);
              await ref
                  .read(censusListProvider.notifier)
                  .addCensusList(censusList);
              setIsLoading(false);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.censusListNotDelete),
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

  void _onIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CensusListOverlay(
          onSave: _addCensusList,
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
                        emptyMessage: AppLocalizations.of(context)!.noItems,
                      ),
          ),
          onIconPressed: _onIconPressed,
        )
      ],
    );
  }
}
