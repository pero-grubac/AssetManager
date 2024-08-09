import 'dart:convert';

import 'package:asset_manager/models/asset_location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const API_KEY = 'AIzaSyD06o4maRDfYNUvDtzb0xQu9b_Gmo23HCQ';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  AssetLocation? _pickedLocation;
  bool _isGettingLocation = false;
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
    if (lat == null || lng == null) return;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng$lat,$lng&key=$API_KEY');
    final result = await http.get(url);
    final resultData = json.decode(result.body);
    final address = resultData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = AssetLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text(
      'No location chosen',
      textAlign: TextAlign.center,
    );
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
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
        Wrap(
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
        )
      ],
    );
  }
}
