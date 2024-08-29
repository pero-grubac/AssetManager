import 'dart:async';

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
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/asset.dart';
import '../models/worker.dart';
import '../providers/util_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssetScreen extends ConsumerStatefulWidget {
  static const id = 'asset_screen';
  const AssetScreen({
    super.key,
    this.worker,
    this.position,
  });
  final Worker? worker;
  final LatLng? position;
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
    _assetsFuture = _loadAssets(); // Load assets when the state is initialized
  }

  Future<void> _loadAssets() async {
    AssetLocation? location;
    if (widget.position != null) {
      location = await ref.read(locationProvider.notifier).findLocationByLatLng(
          widget.position!.latitude, widget.position!.longitude);
    }

    return ref.read(assetProvider.notifier).loadItems(location, widget.worker);
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchAssets(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _addAsset(Asset asset) async {
    setIsLoading(true);
    await ref.read(assetProvider.notifier).addAsset(asset);
    setIsLoading(false);
  }

  Future<bool> _uniqueBarcode(int barcode) async {
    setIsLoading(true);
    final isUnique =
        await ref.read(assetProvider.notifier).uniqueBarcode(barcode);
    setIsLoading(false);
    return isUnique;
  }

  Future<void> _removeAsset(Asset asset) async {
    final canDelete = await ref.read(assetProvider.notifier).canDelete(asset);
    if (!mounted) return;

    if (canDelete) {
      final shouldDelete = await _showUndoSnackBar(asset);

      if (!mounted) return;

      if (shouldDelete) {
        await ref.read(assetProvider.notifier).removeAsset(asset);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(AppLocalizations.of(context)!.assetNotDeleted),
          ),
        );
      }
    }
    if (mounted) {
      await ref.read(assetProvider.notifier).refresh();
    }
  }

  Future<bool> _showUndoSnackBar(Asset asset) async {
    final completer = Completer<bool>();

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.assetDelete),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            completer.complete(false);
          },
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });
    return completer.future;
  }

  Future<void> _editAsset(Asset asset) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetDetailsScreen(
          onSaveAsset: (updatedAsset) async {
            setIsLoading(true);
            await ref.read(assetProvider.notifier).updateAsset(updatedAsset);
            setIsLoading(false);
          },
          asset: asset,
        ),
      ),
    );
  }

  void _onIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AssetDetailsScreen(
          onSaveAsset: _addAsset,
          isUniqueBarcode: _uniqueBarcode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screen(
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
                        emptyMessage: AppLocalizations.of(context)!.noAsset,
                      ),
          ),
          onIconPressed: _onIconPressed,
        ),
        if (_isLoading) const CenteredCircularLoading(),
      ],
    );
  }
}
