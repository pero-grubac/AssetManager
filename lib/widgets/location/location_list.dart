import 'package:asset_manager/models/location.dart';
import 'package:flutter/material.dart';

class LocationList extends StatelessWidget {
  const LocationList({
    super.key,
    required this.locations,
    required this.onRemoveLocation,
  });
  final List<Location> locations;
  final void Function(Location location) onRemoveLocation;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
