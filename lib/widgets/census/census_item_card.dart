import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/screens/census_item_details.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';

import '../../models/asset.dart';

class CensusItemCard extends StatefulWidget {
  const CensusItemCard({super.key, required this.censusItem});
  final CensusItem censusItem;

  @override
  State<CensusItemCard> createState() => _CensusItemCardState();
}

class _CensusItemCardState extends State<CensusItemCard> {
  late Asset? asset;
  late Worker? worker;
  late AssetLocation? assetLocation;
  @override
  void initState() {
    // TODO: read asset/worker/location
    super.initState();
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
    return Card(
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
