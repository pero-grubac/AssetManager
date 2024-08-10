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

  void addLocation(AssetLocation location) async {
    final db = await _getDatabase();
    db.insert(dbName, location.toMap());

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
