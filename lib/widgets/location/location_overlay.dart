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
    final enteredLatitude = _latitudeController.text;
    final enteredLongitude = _longitudeController.text;

    try {
      final newLocation = Location.fromStrings(
        latitude: enteredLatitude,
        longitude: enteredLongitude,
        address: enteredName,
      );

      widget.onAddLocation(newLocation);
      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        _showErrorDialog(e.message);
      } else {
        _showErrorDialog('An unknown error occurred');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ..._buildTextFields(isWideScreen: isWideScreen),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _submitData,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
