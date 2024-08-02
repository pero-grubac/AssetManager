import 'package:asset_manager/models/location.dart';
import 'package:flutter/material.dart';

class LocationOverlay extends StatefulWidget {
  const LocationOverlay({super.key, required this.onAddLocation});
  final void Function(Location location) onAddLocation;
  @override
  State<LocationOverlay> createState() => _LocationOverlayState();
}

class _LocationOverlayState extends State<LocationOverlay> {
  final _nameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _submitData() {
    final enteredName = _nameController.text;
    final enteredLatitude = double.parse(_latitudeController.text);
    final enteredLongitude = double.parse(_longitudeController.text);
    widget.onAddLocation(Location(
        latitude: enteredLatitude,
        longitude: enteredLongitude,
        address: enteredName));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
