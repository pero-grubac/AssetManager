import 'dart:convert';

import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/map_screen.dart';
import 'package:asset_manager/screens/selection_screen.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../util/error_dialog.dart';
import '../util/helper_widgets.dart';
import 'location_card.dart';

const apiKey = 'Insert_Google_API_Key';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectedLocation,
    this.isEditable = true,
    this.isExistingLocation = true,
    this.assetLocation,
    this.isLandscape = false,
  });
  final void Function(AssetLocation assetLocation) onSelectedLocation;
  final bool isEditable;
  final bool isExistingLocation;
  final AssetLocation? assetLocation;
  final bool isLandscape;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  AssetLocation? _pickedLocation;
  bool _isGettingLocation = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String locationImage(AssetLocation? location) {
    if (location == null) return '';
    final lat = location.latitude;
    final lon = location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=$apiKey';
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
    if (!mounted) return;

    if (lat == null || lng == null) {
      ErrorDialog.show(context, AppLocalizations.of(context)!.wrongLocation);
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    await _savePlace(lat, lng);
    if (!mounted) return;
    setState(() {
      _isGettingLocation = false;
    });
  }

  Future<void> _setLocation(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

    try {
      final result = await http.get(url);
      if (!mounted) return;
      if (result.statusCode != 200) {
        throw Exception(AppLocalizations.of(context)!.wrongLocation);
      }
      final resultData = json.decode(result.body);
      if (resultData['results'].isEmpty) {
        throw Exception(AppLocalizations.of(context)!.noAddress);
      }

      final addressComponents = resultData['results'][0]['address_components'];
      String cityName = 'Unknown City';
      for (var component in addressComponents) {
        if (component['types'].contains('locality')) {
          cityName = component['long_name'];
          break;
        }
      }

      if (cityName == 'Unknown City') {
        for (var component in addressComponents) {
          if (component['types'].contains('administrative_area_level_1')) {
            cityName = component['long_name'];
            break;
          }
        }
      }
      for (var component in addressComponents) {
        if (component['types'].contains('administrative_area_level_2')) {
          cityName = component['long_name'];
          break;
        }
      }
      if (cityName == 'Unknown City') {
        cityName = resultData['results'][0]['formatted_address'];
      }

      setState(() {
        _pickedLocation = AssetLocation(
          latitude: latitude,
          longitude: longitude,
          address: cityName,
        );
        _isGettingLocation = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isGettingLocation = false;
      });
      ErrorDialog.show(context, error.toString());
    }
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    await _setLocation(latitude, longitude);
    if (!mounted) return;
    widget.onSelectedLocation(_pickedLocation!);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
    if (!mounted) return;
    if (pickedLocation == null) return;
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  Image _locationImage(AssetLocation location) {
    return Image.network(
      locationImage(location),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _existingLocation() async {
    setState(() {
      _isGettingLocation = true;
    });
    final selectedLocation = await Navigator.push<AssetLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionScreen<AssetLocation>(
          provider: locationProvider,
          onConfirmSelection: (AssetLocation selectedItem) {
            // Only return the selected location, don't pop here
          },
          cardBuilder:
              (AssetLocation item, bool isSelected, void Function() onTap) {
            return LocationCard(
              location: item,
              isSelected: isSelected,
              onTap: onTap,
            );
          },
          title: AppLocalizations.of(context)!.selectLocation,
          emptyMessage: AppLocalizations.of(context)!.noLocation,
        ),
      ),
    );
    setState(() {
      _isGettingLocation = false;
    });
    if (selectedLocation != null) {
      _pickedLocation = selectedLocation;
    } else {
      return;
    }
    widget.onSelectedLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      AppLocalizations.of(context)!.noLocationChosen,
      textAlign: TextAlign.center,
    );

    if (_pickedLocation != null) {
      previewContent = _locationImage(_pickedLocation!);
    }

    if (widget.assetLocation != null) {
      previewContent = GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => MapScreen(
                assetLocation: widget.assetLocation,
                isSelecting: false,
              ),
            ),
          );
        },
        child: _locationImage(widget.assetLocation!),
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
          label: Text(AppLocalizations.of(context)!.currentLocation),
        ),
        TextButton.icon(
          onPressed: _selectOnMap,
          icon: const Icon(Icons.map),
          label: Text(AppLocalizations.of(context)!.selectOnMap),
        ),
        if (widget.isExistingLocation)
          TextButton.icon(
            onPressed: _existingLocation,
            icon: const Icon(Icons.location_city),
            label: Text(AppLocalizations.of(context)!.existingLocation),
          ),
      ],
    );

    // Adjusting when to display the address name
    Widget addressName = RowIconWidget(
      icon: Icons.location_on,
      widget: Expanded(
        child: Text(
            _pickedLocation?.address ?? widget.assetLocation?.address ?? ''),
      ),
    );

    if (!widget.isEditable) {
      buttons = addressName;
      previewContent = GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => MapScreen(
                assetLocation: widget.assetLocation,
                isSelecting: false,
              ),
            ),
          );
        },
        child: _locationImage(widget.assetLocation!),
      );
    }
    if (widget.isLandscape) {
      // Landscape: Buttons to the right of the container
      return Row(
        children: [
          Container(
            height: 170,
            width: MediaQuery.of(context).size.width *
                0.6, // Adjust width based on your layout
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: previewContent,
          ),
          addHorizontalSpace(10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_pickedLocation != null || widget.assetLocation != null)
                addressName,
              addVerticalSpace(5),
              buttons,
            ],
          )),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: previewContent,
          ),
          addVerticalSpace(10),
          if (_pickedLocation != null || widget.assetLocation != null)
            addressName,
          addVerticalSpace(10),
          if (widget.isEditable) buttons,
        ],
      );
    }
  }
}
