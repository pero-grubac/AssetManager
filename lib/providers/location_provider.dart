import 'package:asset_manager/models/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationNotifier extends StateNotifier<List<Location>> {
  LocationNotifier() : super(const []);

  void addLocation(Location location) {
    state = [location, ...state];
  }

  void searchLocation(String query) {
    List<Location> results;
    if (query.isEmpty) {
      results = state;
    } else {
      final queryLower = query.toLowerCase();
      double? queryAsDouble = double.tryParse(query);
      results = state.where((location) {
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
    }
    state = results;
  }

  void removeLocation(Location location) {
    state = state.where((l) => l.id != location.id).toList();
  }

  int indexOfLocation(Location location) {
    return state.indexOf(location);
  }

  void insetLocation(Location location, int index) {
    final newList = [...state];
    newList[index] = location;
    state = newList;
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<Location>>(
  (ref) => LocationNotifier(),
);
