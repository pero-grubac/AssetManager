import 'package:asset_manager/providers/asset_provider.dart';
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
  List<Asset>? _searchedAssets;
  final _searchController = TextEditingController();

  void _addAsset(Asset asset) {
    ref.read(assetProvider.notifier).addAsset(asset);
  }

  void _removeAsset(Asset asset) {}
  void _editAsset(Asset asset) {}
  void _openAssetDetailsScreen() {}
  @override
  Widget build(BuildContext context) {
    // TODO use DismissibleList
    return const Placeholder();
  }
}
