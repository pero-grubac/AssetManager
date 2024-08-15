import 'package:asset_manager/models/asset.dart';
import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import '../models/worker.dart';
import 'database.dart';

class AssetNotifier extends StateNotifier<List<Asset>> {
  AssetNotifier() : super([]);

  Future<void> loadItems(AssetLocation? location, Worker? worker) async {
    final db = await DatabaseHelper().getAssetDatabase();
    List<Asset> assets = [];
    if (location != null && worker != null) {
      final data = await db.query(
        Asset.dbName,
        where: 'assignedLocationId = ? AND assignedPersonId = ?',
        whereArgs: [location.id, worker.id],
      );
      assets = data.map((row) => Asset.fromMap(row)).toList();
    } else if (location != null) {
      final data = await db.query(
        Asset.dbName,
        where: 'assignedLocationId = ?',
        whereArgs: [location.id],
      );
      assets = data.map((row) => Asset.fromMap(row)).toList();
    } else if (worker != null) {
      final data = await db.query(
        Asset.dbName,
        where: 'assignedPersonId = ?',
        whereArgs: [worker.id],
      );
      assets = data.map((row) => Asset.fromMap(row)).toList();
    } else {
      final data = await db.query(Asset.dbName);
      assets = data.map((row) => Asset.fromMap(row)).toList();
    }

    state = assets;
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
