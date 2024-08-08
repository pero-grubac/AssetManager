import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/location/location_card.dart';
import 'package:asset_manager/widgets/location/location_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';
import '../providers/search_provider.dart';
import '../widgets/util/dismissible_list.dart';

class LocationScreen extends ConsumerStatefulWidget {
  static const id = 'location_screen';
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  final _searchController = TextEditingController();

  void _searchLocation(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  void _addLocation(Location location) {
    ref.read(locationProvider.notifier).addLocation(location);
  }

  void _removeLocation(Location location) {
    final workerIndex =
        ref.read(locationProvider.notifier).indexOfLocation(location);
    ref.read(locationProvider.notifier).removeLocation(location);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref
                .read(locationProvider.notifier)
                .insetLocation(location, workerIndex);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      searchController: _searchController,
      onSearchChanged: _searchLocation,
      body: DismissibleList<Location>(
        onRemoveItem: _removeLocation,
        itemBuilder: (context, location) => LocationCard(
          location: location,
        ),
        isEditable: false,
        provider: filteredLocationsProvider,
        emptyMessage: 'No locations found.',
      ),
      overlay: LocationOverlay(
        onAddLocation: _addLocation,
      ),
    );
  }
}
