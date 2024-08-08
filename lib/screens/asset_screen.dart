import 'package:asset_manager/providers/asset_provider.dart';
import 'package:asset_manager/screens/asset_details_screen.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/asset/asset_card.dart';
import 'package:asset_manager/widgets/util/dismissible_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset.dart';

class AssetScreen extends ConsumerStatefulWidget {
  static const id = 'asset_screen';
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  final _searchController = TextEditingController();

  void _searchAssets(String query) {
    ref.read(assetProvider.notifier).searchAssets(query);
  }

  void _addAsset(Asset asset) {
    ref.read(assetProvider.notifier).addAsset(asset);
  }

  void _removeAsset(Asset asset) {
    final assetIndex = ref.read(assetProvider.notifier).indexOfAsset(asset);
    ref.read(assetProvider.notifier).removeAsset(asset);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(assetProvider.notifier).insetAsset(asset, assetIndex);
          },
        ),
      ),
    );
  }

  void _editAsset(Asset asset) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AssetDetailsScreen(
        onSaveAsset: (updatedAsset) {
          ref.read(assetProvider.notifier).updateAsset(updatedAsset);
        },
        asset: asset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
        searchController: _searchController,
        onSearchChanged: _searchAssets,
        body: DismissibleList(
          onRemoveItem: _removeAsset,
          onEditItem: _editAsset,
          isEditable: true,
          itemBuilder: (context, asset) => AssetCard(
            asset: asset,
          ),
          provider: assetProvider,
          emptyMessage: 'No assets found',
        ),
        overlay: AssetDetailsScreen(
          onSaveAsset: _addAsset,
        ));
  }
}
