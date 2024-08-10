import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/widgets/location/location_input.dart';
import 'package:flutter/material.dart';

class LocationOverlay extends StatefulWidget {
  const LocationOverlay({
    super.key,
    required this.onAddLocation,
    this.isEditable = true,
  });
  final void Function(AssetLocation location) onAddLocation;
  final bool isEditable;

  @override
  State<LocationOverlay> createState() => _LocationOverlayState();
}

class _LocationOverlayState extends State<LocationOverlay> {
  AssetLocation? _selectedLocation;

  void _submitData() {
    if (_selectedLocation != null) {
      widget.onAddLocation(_selectedLocation!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
        actions: widget.isEditable
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _submitData,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LocationInput(
          onSelectedLocation: (location) => _selectedLocation = location,
        ),
      ),
    );
  }
}
