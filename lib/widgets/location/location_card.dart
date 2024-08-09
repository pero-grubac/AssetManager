import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/widgets/util/center_row_icon_widget.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    this.onTap,
  });

  final AssetLocation location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: CenterRowIconText(
          icon: Icons.location_city,
          widget: Text(location.address),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              RowIconWidget(
                icon: Icons.navigation,
                widget: Text(location.longitude.toStringAsFixed(6)),
              ),
              const Spacer(),
              RowIconWidget(
                icon: Icons.navigation,
                widget: Text(location.latitude.toStringAsFixed(6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
