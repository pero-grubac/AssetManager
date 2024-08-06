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
    double? enteredLatitude = double.tryParse(_latitudeController.text);
    double? enteredLongitude = double.tryParse(_longitudeController.text);

    if (enteredName.isEmpty) {
      _showErrorDialog('Invalid Name');
      return;
    }
    if (enteredLongitude == null) {
      _showErrorDialog('Invalid longitude');
      return;
    }
    if (enteredLatitude == null) {
      _showErrorDialog('Invalid latitude');
      return;
    }
    widget.onAddLocation(Location(
        latitude: enteredLatitude!,
        longitude: enteredLongitude!,
        address: enteredName));
    Navigator.pop(context);
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
