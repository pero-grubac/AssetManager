import 'package:asset_manager/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationSelectionScreen extends ConsumerStatefulWidget {
  const LocationSelectionScreen({
    super.key,
  });

  @override
  ConsumerState<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState
    extends ConsumerState<LocationSelectionScreen> {
  String? _selectedLocationId;
  late Future<void> _locationFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load the locations asynchronously
    _locationFuture = ref.read(locationProvider.notifier).loadAssetLocations();
  }

  void _selectLocation(String locationId) {
    setState(() {
      _selectedLocationId = locationId;
    });
  }

  void _confirmSelection() {
    final locations = ref.read(locationProvider);
    final selectedLocation = locations.firstWhere(
      (location) => location.id == _selectedLocationId,
    );
    Navigator.pop(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _locationFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    title: const Text('Select Location'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: _selectedLocationId == null
                            ? null
                            : _confirmSelection,
                      ),
                    ],
                  ),
                  body: Consumer(
                    builder: (context, ref, child) {
                      final locations = ref.watch(locationProvider);
                      return ListView.builder(
                        itemCount: locations.length,
                        itemBuilder: (ctx, index) {
                          final location = locations[index];
                          final isSelected = location.id == _selectedLocationId;

                          return Card(
                            child: ListTile(
                              leading: isSelected
                                  ? const Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : const Icon(Icons.circle_outlined),
                              title: Text(location.address),
                              subtitle: Text(
                                  '(${location.latitude.toStringAsFixed(6)},  ${location.longitude.toStringAsFixed(6)})'),
                              onTap: () => _selectLocation(location.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
