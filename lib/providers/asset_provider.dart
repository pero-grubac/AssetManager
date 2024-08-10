import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart' as sql_api;

Future<sql_api.Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'assets.db'),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE assets(
          id TEXT PRIMARY KEY, 
          name TEXT,
           description TEXT,
           barcode INTEGER, 
           price REAL,
           creationDate TEXT, 
           assignedPersonId TEXT,
           assignedLocationId TEXT, 
           imagePath TEXT)
         ''');
    },
    version: 1,
  );
  return db;
}

class AssetNotifier extends StateNotifier<List<Asset>> {
  AssetNotifier() : super([]);
  final dbName = 'assets';

  Future<void> loadAssets() async {
    final db = await _getDatabase();
    final data = await db.query(dbName);
    final assets = data.map((row) => Asset.fromMap(row)).toList();
    state = assets;
  }

  void addAsset(Asset asset) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(asset.image.path);
    final copiedImage = await asset.image.copy('${appDir.path}/$fileName');
    asset.image = copiedImage;

    final db = await _getDatabase();
    db.insert(dbName, asset.toMap());

    state = [asset, ...state];
  }

  void searchAssets(String query) {
    List<Asset> results;
    if (query.isEmpty) {
      results = state;
    } else {
      final queryLower = query.toLowerCase();
      double? queryAsDouble = double.tryParse(query);
      results = state.where((asset) {
        final assetName = asset.name.toLowerCase();
        final assetPrice = asset.price;
        bool matchesName = assetName.contains(queryLower);
        bool matchesPrice =
            queryAsDouble != null && assetPrice == queryAsDouble;
        return matchesPrice || matchesName;
      }).toList();
    }
    state = results;
  }

  void removeAsset(Asset asset) {
    state = state.where((a) => a.id != asset.id).toList();
  }

  int indexOfAsset(Asset asset) {
    return state.indexOf(asset);
  }

  void insetAsset(Asset asset, int index) {
    final newList = [...state];
    newList.insert(index, asset);
    state = newList;
  }

  void updateAsset(Asset updatedAsset) {
    final index = state.indexWhere((asset) => asset.id == updatedAsset.id);
    List<Asset> temp = state;
    temp[index] = updatedAsset;
    state = [...temp];
  }
}

final assetProvider = StateNotifierProvider<AssetNotifier, List<Asset>>(
  (ref) => AssetNotifier(),
);

final filteredAssetsProvider = Provider<List<Asset>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  double? queryAsDouble = double.tryParse(query);

  final assets = ref.watch(assetProvider);
  if (query.isEmpty) return assets;
  return assets.where((asset) {
    final assetName = asset.name.toLowerCase();
    final assetPrice = asset.price;
    bool matchesName = assetName.contains(query);
    bool matchesPrice = queryAsDouble != null && assetPrice == queryAsDouble;
    return matchesPrice || matchesName;
  }).toList();
});
