import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/location/location_card.dart';
import 'package:asset_manager/screens/add_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset_location.dart';
import '../providers/search_provider.dart';
import '../widgets/util/centered_circular_loading.dart';
import '../widgets/util/dismissible_list.dart';

class LocationScreen extends ConsumerStatefulWidget {
  static const id = 'location_screen';
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  final _searchController = TextEditingController();
  late Future<void> _locationFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _locationFuture = ref.read(locationProvider.notifier).loadItems();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchLocation(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _addLocation(AssetLocation location) async {
    setIsLoading(true);
    await ref.read(locationProvider.notifier).addLocation(location);
    setIsLoading(false);
  }

  Future<void> _removeLocation(AssetLocation location) async {
    final locationNotifier = ref.read(locationProvider.notifier);

    final locationIndex = locationNotifier.indexOfLocation(location);
    final updatedState =
        locationNotifier.state.where((l) => l.id != location.id).toList();
    locationNotifier.state = updatedState;

    final shouldDelete = await locationNotifier.removeLocation(location);
    if (!shouldDelete) {
      // Reinstate the location back to the list if deletion is not allowed
      locationNotifier.state = [
        ...updatedState.sublist(0, locationIndex),
        location,
        ...updatedState.sublist(locationIndex)
      ];
    }
    _showUndoSnackBar(location, locationIndex, shouldDelete);
  }

  void _showUndoSnackBar(
      AssetLocation location, int locationIndex, bool shouldDelete) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (shouldDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Location deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setIsLoading(true);
              await ref
                  .read(locationProvider.notifier)
                  .insetLocation(location, locationIndex);
              setIsLoading(false);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Location can not be deleted.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: _locationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Screen(
              searchController: _searchController,
              onSearchChanged: _searchLocation,
              body: DismissibleList<AssetLocation>(
                onRemoveItem: _removeLocation,
                itemBuilder: (context, location) => LocationCard(
                  location: location,
                  isSelectable: false,
                ),
                isEditable: false,
                provider: filteredLocationsProvider,
                emptyMessage: 'No locations found.',
              ),
              overlay: AddLocationScreen(
                onAddLocation: _addLocation,
                isExistingLocation: false,
              ),
            );
          },
        ),
        if (_isLoading)
          const CenteredCircularLoading(), // Overlay a loading indicator while adding/removing items
      ],
    );
  }
}
