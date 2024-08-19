import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/asset_provider.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/providers/worker_provider.dart';
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
import '../providers/search_provider.dart';

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
    _initializeAssets();
  }

  void _initializeAssets() async {
    AssetLocation? location;
    if (widget.position != null) {
      location = await ref.read(locationProvider.notifier).findLocationByLatLng(
          widget.position!.latitude, widget.position!.longitude);
    }

    _assetsFuture =
        ref.read(assetProvider.notifier).loadItems(location, widget.worker);
    setState(() {}); // Trigger a rebuild after assets are loaded
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

  Future<void> _removeAsset(Asset asset) async {
    final shouldDelete =
        await ref.read(assetProvider.notifier).removeAsset(asset);

    _showUndoSnackBar(asset, shouldDelete);
  }

  void _showUndoSnackBar(Asset asset, bool shouldDelete) {
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
              await ref.read(assetProvider.notifier).addAsset(asset);
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

  Future<void> _editAsset(Asset asset) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetDetailsScreen(
          onSaveAsset: (updatedAsset) async {
            setIsLoading(true);

            final oldAsset = await ref
                .read(assetProvider.notifier)
                .findAssetById(updatedAsset.id);

            /*   if (location.id != oldAsset?.assignedLocationId) {
              await ref.read(locationProvider.notifier).addLocation(location);
            }*/
            /*   final oldWorker = await ref
                .read(workerProvider.notifier)
                .findWorkerById(updatedAsset.assignedPersonId);
            if (worker.id != oldWorker?.id) {
              await ref.read(workerProvider.notifier).addWorker(worker);
            }*/
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
                        emptyMessage: 'No assets found',
                      ),
          ),
          overlay: AssetDetailsScreen(
            onSaveAsset: _addAsset,
          ),
        ),
        if (_isLoading) const CenteredCircularLoading(),
      ],
    );
  }
}
