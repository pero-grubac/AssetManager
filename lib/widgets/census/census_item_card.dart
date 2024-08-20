import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/asset.dart';
import '../../providers/asset_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/worker_provider.dart';

class CensusItemCard extends ConsumerStatefulWidget {
  const CensusItemCard({super.key, required this.censusItem});
  final CensusItem censusItem;

  @override
  ConsumerState<CensusItemCard> createState() => _CensusItemCardState();
}

class _CensusItemCardState extends ConsumerState<CensusItemCard> {
  late Asset? asset;
  late Worker? worker;
  late AssetLocation? assetLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final assetResult = await ref
        .read(assetProvider.notifier)
        .findAssetById(widget.censusItem.assetId);
    final workerResult = await ref
        .read(workerProvider.notifier)
        .findWorkerById(widget.censusItem.newPersonId);
    final locationResult = await ref
        .read(locationProvider.notifier)
        .findLocationById(widget.censusItem.newLocationId);

    if (mounted) {
      setState(() {
        asset = assetResult;
        worker = workerResult;
        assetLocation = locationResult;
        _isLoading = false;
      });
    }
  }

  void openOverlay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CensusItemDetails(
          censusItem: widget.censusItem,
          isEditable: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(asset!.image),
              ),
              title: RowIconWidget(
                icon: Icons.person_2,
                widget: Expanded(child: Text(worker!.fullName)),
              ),
              subtitle: RowIconWidget(
                icon: Icons.location_city,
                widget: Expanded(
                  child: Text(assetLocation!.address),
                ),
              ),
              onTap: openOverlay,
            ),
          );
  }
}
