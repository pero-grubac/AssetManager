import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/widgets/location/location_overlay.dart';
import 'package:asset_manager/widgets/util/center_row_icon_widget.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
  });

  final AssetLocation location;

  @override
  Widget build(BuildContext context) {
    void openOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => LocationOverlay(
          isEditable: false,
          onAddLocation: (AssetLocation location) {},
          location: location,
        ),
      );
    }

    return Card(
      child: ListTile(
        onTap: openOverlay,
        title: CenterRowIconText(
          icon: Icons.location_city,
          widget: Expanded(child: Text(location.address)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              RowIconWidget(
                icon: Icons.navigation,
                widget: Text(location.latitude.toStringAsFixed(6)),
              ),
              const Spacer(),
              RowIconWidget(
                icon: Icons.navigation,
                widget: Text(location.longitude.toStringAsFixed(6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
