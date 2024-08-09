import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationNotifier extends StateNotifier<List<AssetLocation>> {
  LocationNotifier() : super(const []);

  void addLocation(AssetLocation location) {
    state = [location, ...state];
  }

  void removeLocation(AssetLocation location) {
    state = state.where((l) => l.id != location.id).toList();
  }

  int indexOfLocation(AssetLocation location) {
    return state.indexOf(location);
  }

  void insetLocation(AssetLocation location, int index) {
    final newList = [...state];
    newList[index] = location;
    state = newList;
  }

  AssetLocation? findLocationById(String id) {
    try {
      return state.firstWhere((location) => location.id == id);
    } catch (e) {
      return null; // Return null if no location is found with the given ID
    }
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, List<AssetLocation>>(
  (ref) => LocationNotifier(),
);

final filteredLocationsProvider = Provider<List<AssetLocation>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  double? queryAsDouble = double.tryParse(query);

  final locations = ref.watch(locationProvider);
  if (query.isEmpty) return locations;
  return locations.where((location) {
    final locationAddress = location.address.toLowerCase();
    final locationLongitude = location.longitude;
    final locationLatitude = location.latitude;

    bool matchesAddress = locationAddress.contains(query);
    bool matchesLongitude =
        queryAsDouble != null && locationLongitude == queryAsDouble;
    bool matchesLatitude =
        queryAsDouble != null && locationLatitude == queryAsDouble;

    return matchesAddress || matchesLongitude || matchesLatitude;
  }).toList();
});
