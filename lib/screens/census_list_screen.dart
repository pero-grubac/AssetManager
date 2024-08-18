import 'package:asset_manager/providers/census_list_provider.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/census/census_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/census_list.dart';
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
  Future<void> _removeCensusList(CensusList censusList) async {}
  Future<void> _editCensusList(CensusList censusList) async {}

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
            // TODO census list detail overlay,add button for census items
            overlay: const CensusItemDetails())
      ],
    );
  }
}
