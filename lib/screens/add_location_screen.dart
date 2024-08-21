import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/widgets/location/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({
    super.key,
    required this.onAddLocation,
    this.isEditable = true,
    this.isExistingLocation = true,
    this.location,
  });
  final void Function(AssetLocation location) onAddLocation;
  final bool isEditable;
  final bool isExistingLocation;
  final AssetLocation? location;
  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  AssetLocation? _selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      _selectedLocation = widget.location;
    }
  }

  void _submitData() {
    if (_selectedLocation != null) {
      widget.onAddLocation(_selectedLocation!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isEditable
            ? Text(AppLocalizations.of(context)!.addLocation)
            : Text(AppLocalizations.of(context)!.yourLocation),
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
          isEditable: widget.isEditable,
          assetLocation: _selectedLocation,
          isExistingLocation: widget.isExistingLocation,
        ),
      ),
    );
  }
}
