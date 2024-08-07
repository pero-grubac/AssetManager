import 'package:flutter/material.dart';
import 'package:asset_manager/models/asset.dart';

import '../util/center_icon_text_row.dart';
import '../util/icon_text_row.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({super.key, required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: CenterRowIconText(
          icon: Icons.label,
          text: asset.name,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconTextRow(
                  icon: Icons.attach_money,
                  text: asset.price.toStringAsFixed(2),
                ),
              ],
            ),
            Row(
              children: [
                IconTextRow(
                  icon: Icons.calendar_today,
                  text: asset.creationDate.toLocal().toString().split(' ')[0],
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
