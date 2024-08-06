import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/location/location_card.dart';
import 'package:asset_manager/widgets/location/location_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';
import '../widgets/util/dismissible_list.dart';

class LocationScreen extends ConsumerStatefulWidget {
  static const id = 'location_screen';
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  final List<Location> _locations = [
    Location(
      latitude: 12,
      longitude: 12,
      address: 'address',
    ),
    Location(
      latitude: 13,
      longitude: 13,
      address: 'address2',
    ),
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
    ref.read(locationProvider.notifier).addLocation(location);
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

    Widget mainContent = const Center(
      child: Text('No locations found.'),
    );
    if (displayedLocations.isNotEmpty) {
      mainContent = DismissibleList<Location>(
        //  items: displayedLocations,
        onRemoveItem: _removeLocation,
        itemBuilder: (context, location) => LocationCard(
          location: location,
        ),
        isEditable: false,
        provider: locationProvider,
      );
    }
    return Screen(
      searchController: _searchController,
      onSearchChanged: _searchLocation,
      body: mainContent,
      overlay: LocationOverlay(
        onAddLocation: _addLocation,
      ),
    );
  }
}
