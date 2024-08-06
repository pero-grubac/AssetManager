import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/location/location_card.dart';
import 'package:asset_manager/widgets/location/location_overlay.dart';
import 'package:flutter/material.dart';

import '../models/location.dart';
import '../widgets/dismissible_list.dart';

class LocationScreen extends StatefulWidget {
  static const id = 'location_screen';
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final List<Location> _locations = [
    Location(latitude: 12, longitude: 12, address: 'address'),
    Location(latitude: 13, longitude: 13, address: 'bddress'),
  ];
  List<Location>? _searchedLocations;
  final _searchController = TextEditingController();

  void _searchLocation(String query) {
    final queryLower = query.toLowerCase();
    double? queryAsDouble = double.tryParse(query);

    final searchedLocations = _locations.where((location) {
      final locationAddress = location.address.toLowerCase();
      final locationLongitude = location.longitude;
      final locationLatitude = location.latitude;

      bool matchesAddress = locationAddress.contains(queryLower);
      bool matchesLongitude =
          queryAsDouble != null && locationLongitude == queryAsDouble;
      bool matchesLatitude =
          queryAsDouble != null && locationLatitude == queryAsDouble;

      return matchesAddress || matchesLongitude || matchesLatitude;
    }).toList();

    setState(() {
      _searchedLocations = searchedLocations;
    });
  }

  void _addLocation(Location location) {
    setState(() {
      _locations.insert(0, location);
    });
  }

  void _removeLocation(Location location) {
    final workerIndex = _locations.indexOf(location);
    setState(() {
      _locations.remove(location);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _locations.insert(workerIndex, location);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedLocations = _searchedLocations ?? _locations;
    print(displayedLocations);
    Widget mainContent = const Center(
      child: Text('No locations found.'),
    );
    if (displayedLocations.isNotEmpty) {
      mainContent = DismissibleList<Location>(
        items: _locations,
        onRemoveItem: _removeLocation,
        itemBuilder: (context, location) => LocationCard(location: location),
      );
    }
    return Screen(
        searchController: _searchController,
        onSearchChanged: _searchLocation,
        body: mainContent,
        overlay: LocationOverlay(
          onAddLocation: _addLocation,
        ));
  }
}
