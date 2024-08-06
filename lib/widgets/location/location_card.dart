import 'package:asset_manager/models/location.dart';
import 'package:asset_manager/widgets/util/center_icon_text_row.dart';
import 'package:asset_manager/widgets/util/icon_text_row.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.location});
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            CenterRowIconText(
              icon: Icons.location_city,
              text: location.address,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                IconTextRow(
                  icon: Icons.navigation,
                  text: location.longitude.toStringAsFixed(6),
                ),
                const Spacer(),
                IconTextRow(
                  icon: Icons.navigation,
                  text: location.latitude.toStringAsFixed(6),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
