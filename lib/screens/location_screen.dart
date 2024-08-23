import 'dart:async';

import 'package:asset_manager/providers/location_provider.dart';
import 'package:asset_manager/screens/screen.dart';
import 'package:asset_manager/widgets/location/location_card.dart';
import 'package:asset_manager/screens/add_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/asset_location.dart';
import '../providers/util_provider.dart';
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
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    setState(() {
      _locationFuture = ref.read(locationProvider.notifier).loadItems();
    });
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
    final canDelete = await locationNotifier.canDelete(location);

    if (!mounted) return;

    if (canDelete) {
      final shouldDelete = await _showUndoSnackBar(location);

      if (!mounted) return;

      if (shouldDelete) {
        await locationNotifier.removeLocation(location);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(AppLocalizations.of(context)!.locationNotDeleted),
          ),
        );
      }
    }
    if (mounted) {
      await locationNotifier.refresh();
    }
  }

  Future<bool> _showUndoSnackBar(AssetLocation location) async {
    final completer = Completer<bool>();

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.locationDelete),
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            completer.complete(false);
          },
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });
    return completer.future;
  }

  void _onIconPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddLocationScreen(
          onAddLocation: _addLocation,
          isExistingLocation: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screen(
          searchController: _searchController,
          onSearchChanged: _searchLocation,
          body: FutureBuilder(
            future: _locationFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const CenteredCircularLoading()
                    : DismissibleList<AssetLocation>(
                        onRemoveItem: _removeLocation,
                        itemBuilder: (context, location) => LocationCard(
                          location: location,
                          isSelectable: false,
                        ),
                        isEditable: false,
                        provider: filteredLocationsProvider,
                        emptyMessage: 'No locations found.',
                      ),
          ),
          onIconPressed: _onIconPressed,
        ),

        if (_isLoading)
          const CenteredCircularLoading(), // Overlay a loading indicator while adding/removing items
      ],
    );
  }
}
