import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/database.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/asset.dart';

class LocationNotifier extends StateNotifier<List<AssetLocation>> {
  LocationNotifier() : super(const []);

  Future<void> loadItems() async {
    final db = await DatabaseHelper().getLocationDatabase();
    final data = await db.query(
      AssetLocation.dbName,
      orderBy: 'createdAt DESC',
    );
    final locations = data.map((row) => AssetLocation.fromMap(row)).toList();
    state = locations;
  }

  Future<void> addLocation(AssetLocation location) async {
    final db = await DatabaseHelper().getLocationDatabase();
    final l = await findLocationById(location.id);
    if (l == null) {
      await db.insert(
        AssetLocation.dbName,
        location.toMap(),
      );
      state = [location, ...state];
    }
  }

  Future<bool> removeLocation(AssetLocation location) async {
    final db = await DatabaseHelper().getLocationDatabase();
    final assetDb = await DatabaseHelper().getAssetDatabase();

    final result = await assetDb.query(
      Asset.dbName,
      where: 'assignedLocationId = ?',
      whereArgs: [location.id],
    );

    if (result.isNotEmpty) {
      return false;
    }
    await db.delete(
      AssetLocation.dbName,
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state = state.where((l) => l.id != location.id).toList();
    return true;
  }

  int indexOfLocation(AssetLocation location) {
    return state.indexOf(location);
  }

  Future<void> insetLocation(AssetLocation location, int index) async {
    final db = await DatabaseHelper().getLocationDatabase();
    await db.update(
      AssetLocation.dbName,
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state = [location, ...state];
  }

  Future<AssetLocation?> findLocationById(String id) async {
    final db = await DatabaseHelper().getLocationDatabase();
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
    final db = await DatabaseHelper().getLocationDatabase();
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
    await DatabaseHelper().closeDatabases();
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
