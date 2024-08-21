import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/screens/add_location_screen.dart';
import 'package:asset_manager/widgets/util/center_row_icon_widget.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    this.onTap,
    this.isSelected = false,
    this.isSelectable = true,
  });

  final AssetLocation location;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isSelectable;
  @override
  Widget build(BuildContext context) {
    void openOverlay() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => AddLocationScreen(
            isEditable: false,
            onAddLocation: (AssetLocation location) {},
            location: location,
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: isSelectable
            ? isSelected
                ? const Icon(Icons.check_circle)
                : const Icon(Icons.circle_outlined)
            : null,
        onTap: onTap ?? openOverlay,
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
