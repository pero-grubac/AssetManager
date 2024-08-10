import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart' as sql_api;
import 'package:path/path.dart' as path;

Future<sql_api.Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'locations.db'),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE locations(
           id TEXT PRIMARY KEY, 
           latitude REAL,
           longitude REAL,
           address TEXT)
         ''');
    },
    version: 1,
  );
  return db;
}

class LocationNotifier extends StateNotifier<List<AssetLocation>> {
  LocationNotifier() : super(const []);
  final dbName = 'locations';

  Future<void> loadAssetLocations() async {
    final db = await _getDatabase();
    final data = await db.query(dbName);
    final locations = data.map((row) => AssetLocation.fromMap(row)).toList();
    state = locations;
  }

  Future<void> addLocation(AssetLocation location) async {
    final db = await _getDatabase();
    await db.insert(dbName, location.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    state = [location, ...state];
  }

  Future<void> removeLocation(AssetLocation location) async {
    final db = await _getDatabase();
    await db.delete(
      dbName,
      where: 'id = ?',
      whereArgs: [location.id],
    );

    state = state.where((l) => l.id != location.id).toList();
  }

  int indexOfLocation(AssetLocation location) {
    return state.indexOf(location);
  }

  Future<void> insetLocation(AssetLocation location, int index) async {
    final db = await _getDatabase();
    await db.update(
      dbName,
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );

    final newList = [...state];
    newList[index] = location;
    state = newList;
  }

  Future<AssetLocation?> findLocationById(String id) async {
    final db = await _getDatabase();
    final data = await db.query(
      dbName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return AssetLocation.fromMap(data.first);
    } else {
      return null;
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
