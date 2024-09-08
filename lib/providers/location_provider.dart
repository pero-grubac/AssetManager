import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/database.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/census_item.dart';

class LocationNotifier extends StateNotifier<List<AssetLocation>> {
  LocationNotifier() : super(const []);

  Future<void> loadItems() async {
    final db = await DatabaseHelper().getDatabase();
    final data = await db.query(
      AssetLocation.dbName,
      orderBy: 'createdAt DESC',
    );
    final locations = data.map((row) => AssetLocation.fromMap(row)).toList();
    state = locations;
  }

  Future<void> addLocation(AssetLocation location) async {
    final db = await DatabaseHelper().getDatabase();
    final l = await findLocationById(location.id);
    if (l == null) {
      await db.insert(
        AssetLocation.dbName,
        location.toMap(),
      );
      state = [location, ...state];
    }
  }

  Future<bool> canDelete(AssetLocation location) async {
    final ciDb = await DatabaseHelper().getDatabase();

    final result = await ciDb.query(
      CensusItem.dbName,
      where: 'oldLocationId = ? OR newLocationId = ?',
      whereArgs: [location.id, location.id],
    );

    if (result.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> refresh() async {
    loadItems();
  }

  Future<void> removeLocation(AssetLocation location) async {
    final db = await DatabaseHelper().getDatabase();

    await db.delete(
      AssetLocation.dbName,
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state = state.where((l) => l.id != location.id).toList();
  }

  int indexOfLocation(AssetLocation location) {
    return state.indexOf(location);
  }

  Future<void> insetLocation(AssetLocation location, int index) async {
    final db = await DatabaseHelper().getDatabase();
    await db.update(
      AssetLocation.dbName,
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state = [location, ...state];
  }

  Future<AssetLocation?> findLocationById(String id) async {
    final db = await DatabaseHelper().getDatabase();
    final data = await db.query(
      AssetLocation.dbName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return AssetLocation.fromMap(data.first);
    } else {
      return null;
    }
  }

  Future<AssetLocation?> findLocationByLatLng(
      double latitude, double longitude) async {
    final db = await DatabaseHelper().getDatabase();
    final data = await db.query(
      AssetLocation.dbName,
      where: 'latitude = ? AND longitude = ?',
      whereArgs: [latitude, longitude],
    );
    if (data.isNotEmpty) {
      return AssetLocation.fromMap(data.first);
    } else {
      return null;
    }
  }

  @override
  void dispose() async {
    await DatabaseHelper().closeDatabase();
    super.dispose();
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
