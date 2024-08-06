import 'package:asset_manager/models/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationNotifier extends StateNotifier<List<Location>> {
  LocationNotifier() : super(const []);

  void addLocation(Location location) {
    state = [location, ...state];
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<Location>>(
  (ref) => LocationNotifier(),
);
