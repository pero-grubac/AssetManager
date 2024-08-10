import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/asset_provider.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/asset_details_screen.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/asset/asset_card.dart';
import 'package:asset_manager/widgets/util/centered_circular_loading.dart';
import 'package:asset_manager/widgets/util/dismissible_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset.dart';
import '../providers/search_provider.dart';

class AssetScreen extends ConsumerStatefulWidget {
  static const id = 'asset_screen';
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  final _searchController = TextEditingController();
  late Future<void> _assetsFuture;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _assetsFuture = ref.read(assetProvider.notifier).loadAssets();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchAssets(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _addAsset(Asset asset, AssetLocation location) async {
    setIsLoading(true);
    await ref.read(locationProvider.notifier).addLocation(location);
    await ref.read(assetProvider.notifier).addAsset(asset);
    setIsLoading(false);
  }

  Future<void> _removeAsset(Asset asset) async {
    final assetIndex = ref.read(assetProvider.notifier).indexOfAsset(asset);
    ref.read(assetProvider.notifier).removeAsset(asset);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setIsLoading(true);
            await ref
                .read(assetProvider.notifier)
                .insetAsset(asset, assetIndex);
            setIsLoading(false);
          },
        ),
      ),
    );
  }

  Future<void> _editAsset(Asset asset) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetDetailsScreen(
          onSaveAsset: (updatedAsset, location) async {
            setIsLoading(true);

            final oldAsset = await ref
                .read(assetProvider.notifier)
                .findAssetById(updatedAsset.id);

            if (location.id != oldAsset?.assignedLocationId) {
              await ref.read(locationProvider.notifier).addLocation(location);
            }

            await ref.read(assetProvider.notifier).updateAsset(updatedAsset);
            setIsLoading(false);
          },
          asset: asset,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CenteredCircularLoading()
        : Screen(
            searchController: _searchController,
            onSearchChanged: _searchAssets,
            body: FutureBuilder(
              future: _assetsFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const CenteredCircularLoading()
                      : DismissibleList(
                          onRemoveItem: _removeAsset,
                          onEditItem: _editAsset,
                          isEditable: true,
                          itemBuilder: (context, asset) => AssetCard(
                            asset: asset,
                          ),
                          provider: filteredAssetsProvider,
                          emptyMessage: 'No assets found',
                        ),
            ),
            overlay: AssetDetailsScreen(
              onSaveAsset: _addAsset,
            ));
  }
}
