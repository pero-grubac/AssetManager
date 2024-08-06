import 'package:asset_manager/models/location.dart';
import 'package:asset_manager/widgets/util/center_icon_text_row.dart';
import 'package:asset_manager/widgets/util/icon_text_row.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    this.onTap,
  });

  final Location location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: CenterRowIconText(
          icon: Icons.location_city,
          text: location.address,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
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
          ),
        ),
      ),
    );
  }
}
