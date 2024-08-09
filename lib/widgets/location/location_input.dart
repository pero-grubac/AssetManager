import 'dart:convert';

import 'package:asset_manager/models/asset_location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../util/error_dialog.dart';

const API_KEY = 'AIzaSyD06o4maRDfYNUvDtzb0xQu9b_Gmo23HCQ';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectedLocation,
    this.isEditable = true,
    this.assetLocation,
  });
  final void Function(AssetLocation assetLocation) onSelectedLocation;
  final bool isEditable;
  final AssetLocation? assetLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  AssetLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String locationImage(AssetLocation? location) {
    if (location == null) return '';
    final lat = location!.latitude;
    final lon = location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=$API_KEY';
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      ErrorDialog.show(
          context, 'Something went wrong with getting the location');
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$API_KEY');

    try {
      final result = await http.get(url);

      if (result.statusCode != 200) {
        throw Exception('Failed to fetch location');
      }
      final resultData = json.decode(result.body);
      if (resultData['results'].isEmpty) {
        throw Exception('No address found');
      }
      final address = resultData['results'][0]['formatted_address'];

      setState(() {
        _pickedLocation = AssetLocation(
          latitude: lat,
          longitude: lng,
          address: address,
        );
        _isGettingLocation = false;
      });
    } catch (error) {
      setState(() {
        _isGettingLocation = false;
      });
      ErrorDialog.show(context, error.toString());
    }
    widget.onSelectedLocation(_pickedLocation!);
  }

  void _pickLocationOnMap() {}
  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text(
      'No location chosen',
      textAlign: TextAlign.center,
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage(_pickedLocation),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    Widget buttons = Wrap(
      spacing: 8.0, // Space between buttons horizontally
      runSpacing: 4.0, // Space between buttons vertically if they wrap
      alignment: WrapAlignment.center,
      children: [
        TextButton.icon(
          onPressed: _getCurrentLocation,
          icon: const Icon(Icons.location_on),
          label: const Text('Get current location'),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.map),
          label: const Text('Select on map'),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.location_city),
          label: const Text('Existing location'),
        ),
      ],
    );
    if (!widget.isEditable) {
      buttons = Text(widget.assetLocation!.address);
      previewContent = Image.network(
        locationImage(widget.assetLocation),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(
          height: 10,
        ),
        buttons
      ],
    );
  }
}
