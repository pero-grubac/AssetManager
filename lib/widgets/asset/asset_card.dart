import 'package:flutter/material.dart';
import 'package:asset_manager/models/asset.dart';

import '../util/center_row_icon_widget.dart';
import '../util/row_icon_widget.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({super.key, required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: CenterRowIconText(
          icon: Icons.label,
          widget: Text(asset.name),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RowIconWidget(
                  icon: Icons.attach_money,
                  widget: Text(asset.price.toStringAsFixed(2)),
                ),
              ],
            ),
            Row(
              children: [
                RowIconWidget(
                  icon: Icons.calendar_today,
                  widget: Text(
                      asset.creationDate.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.more_vert),
        onTap: () {
          // Define your onTap functionality here
        },
      ),
    );
  }
}
