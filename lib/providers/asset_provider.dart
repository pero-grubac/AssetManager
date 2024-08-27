import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import '../models/census_item.dart';
import '../models/worker.dart';
import 'database.dart';

class AssetNotifier extends StateNotifier<List<Asset>> {
  AssetNotifier() : super([]);

  Future<void> loadItems(AssetLocation? location, Worker? worker) async {
    final db = await DatabaseHelper().getAssetDatabase();
    List<Asset> assets = [];
    if (location != null) {
      final assetIds = await getAssetsByLocation(location.id);
      final futures = assetIds.map((id) => findAssetById(id)).toList();
      final results = await Future.wait(futures);
      assets = results.where((asset) => asset != null).cast<Asset>().toList();
    } else if (worker != null) {
      final assetIds = await getAssetsByWorker(worker.id);
      final futures = assetIds.map((id) => findAssetById(id)).toList();
      final results = await Future.wait(futures);
      assets = results.where((asset) => asset != null).cast<Asset>().toList();
    } else {
      final data = await db.query(
        Asset.dbName,
        orderBy: 'creationDate DESC',
      );
      assets = data.map((row) => Asset.fromMap(row)).toList();
    }
    assets.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    state = assets;
  }

  Future<void> refresh() async {
    await loadItems(null, null);
  }

  Future<List<String>> getAssetsByWorker(String workerId) async {
    final db = await DatabaseHelper().getCensusItemDatabase();

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT ci.assetId
    FROM ${CensusItem.dbName} ci
    JOIN (
      SELECT assetId, MAX(id) as maxId
      FROM ${CensusItem.dbName}
      GROUP BY assetId
    ) latest_ci ON ci.id = latest_ci.maxId
    WHERE ci.newPersonId = ?
  ''', [workerId]);

    return results.map((row) => row['assetId'] as String).toList();
  }

  Future<List<String>> getAssetsByLocation(String locationId) async {
    final db = await DatabaseHelper().getCensusItemDatabase();

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT ci.assetId
    FROM ${CensusItem.dbName} ci
    JOIN (
      SELECT assetId, MAX(id) as maxId
      FROM ${CensusItem.dbName}
      GROUP BY assetId
    ) latest_ci ON ci.id = latest_ci.maxId
    WHERE ci.newLocationId = ?
  ''', [locationId]);

    return results.map((row) => row['assetId'] as String).toList();
  }

  Future<void> addAsset(Asset asset) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(asset.image.path);
    final copiedImage = await asset.image.copy('${appDir.path}/$fileName');
    asset.image = copiedImage;

    final db = await DatabaseHelper().getAssetDatabase();
    db.insert(Asset.dbName, asset.toMap());

    state = [asset, ...state];
  }

  Future<bool> uniqueBarcode(int barcode) async {
    final db = await DatabaseHelper().getAssetDatabase();
    final data = await db.query(
      Asset.dbName,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    return data.isEmpty;
  }

  Future<bool> canDelete(Asset asset) async {
    final ciDB = await DatabaseHelper().getCensusItemDatabase();
    final result = await ciDB.query(
      CensusItem.dbName,
      where: 'assetId = ?',
      whereArgs: [asset.id],
    );
    if (result.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> removeAsset(Asset asset) async {
    final db = await DatabaseHelper().getAssetDatabase();

    await db.delete(
      Asset.dbName,
      where: 'id = ?',
      whereArgs: [asset.id],
    );
    if (await asset.image.exists()) {
      await asset.image.delete();
    }
    state = state.where((a) => a.id != asset.id).toList();
  }

  int indexOfAsset(Asset asset) {
    return state.indexOf(asset);
  }

  Future<void> insetAsset(Asset asset, int index) async {
    final db = await DatabaseHelper().getAssetDatabase();
    await db.update(
      Asset.dbName,
      asset.toMap(),
      where: 'id = ?',
      whereArgs: [asset.id],
    );
    final newList = [...state];
    newList.insert(index, asset);
    state = newList;
  }

  Future<void> updateAsset(Asset updatedAsset) async {
    final db = await DatabaseHelper().getAssetDatabase();
    await db.update(
      Asset.dbName,
      updatedAsset.toMap(),
      where: 'id = ?',
      whereArgs: [updatedAsset.id],
    );

    final index = state.indexWhere((asset) => asset.id == updatedAsset.id);
    List<Asset> temp = state;
    temp[index] = updatedAsset;
    state = [...temp];
  }

  Future<Asset?> findAssetById(String id) async {
    final db = await DatabaseHelper().getAssetDatabase();
    final data = await db.query(
      Asset.dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isNotEmpty) {
      return Asset.fromMap(data.first);
    } else {
      return null;
    }
  }

  Future<Asset?> findAssetByBarcode(int barcode) async {
    final db = await DatabaseHelper().getAssetDatabase();
    final data = await db.query(
      Asset.dbName,
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    if (data.isNotEmpty) {
      return Asset.fromMap(data.first);
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

final assetProvider = StateNotifierProvider<AssetNotifier, List<Asset>>(
  (ref) => AssetNotifier(),
);

final filteredAssetsProvider = Provider<List<Asset>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  double? queryAsDouble = double.tryParse(query);
  int? queryAsInt = int.tryParse(query);
  final assets = ref.watch(assetProvider);
  if (query.isEmpty) return assets;
  return assets.where((asset) {
    final assetName = asset.name.toLowerCase();
    final assetPrice = asset.price;
    final assetBarcode = asset.barcode;
    bool matchesName = assetName.contains(query);
    bool matchesPrice = queryAsDouble != null && assetPrice == queryAsDouble;
    bool matchesBarcode = queryAsInt != null && queryAsInt == assetBarcode;
    return matchesPrice || matchesName || matchesBarcode;
  }).toList();
});
