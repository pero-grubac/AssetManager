import 'package:asset_manager/screens/asset_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:asset_manager/models/asset.dart';

import '../util/center_row_icon_widget.dart';
import '../util/row_icon_widget.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({super.key, required this.asset});
  final Asset asset;

  @override
  Widget build(BuildContext context) {
    void openOverlay() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssetDetailsScreen(
            asset: asset,
            isEditable: false,
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        title: CenterRowIconText(
          icon: Icons.business_center,
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
                const Spacer(),
                RowIconWidget(
                  icon: Icons.calendar_today,
                  widget: Text(
                      asset.creationDate.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),
          ],
        ),
        onTap: openOverlay,
      ),
    );
  }
}
