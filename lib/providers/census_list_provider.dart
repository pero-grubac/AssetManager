import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/census_list.dart';
import 'package:asset_manager/providers/database.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CensusListNotifier extends StateNotifier<List<CensusList>> {
  CensusListNotifier() : super([]);
  Future<void> loadItems() async {
    final db = await DatabaseHelper().getCensusListDatabase();
    final data = await db.query(
      CensusList.dbName,
      orderBy: 'creationDate DESC',
    );
    final items = data.map((row) => CensusList.fromMap(row)).toList();
    state = items;
  }

  Future<void> addCensusList(CensusList censusList) async {
    final db = await DatabaseHelper().getCensusListDatabase();
    final cl = await findCensusListById(censusList.id);
    if (cl == null) {
      await db.insert(
        CensusList.dbName,
        censusList.toMap(),
      );
      state = [censusList, ...state];
    }
  }

  Future<bool> removeCensusList(CensusList censusList) async {
    final db = await DatabaseHelper().getCensusListDatabase();
    final itemDB = await DatabaseHelper().getCensusItemDatabase();
    final result = await itemDB.query(
      CensusItem.dbName,
      where: 'censusListId = ?',
      whereArgs: [censusList.id],
    );
    if (result.isNotEmpty) {
      return false;
    }
    await db.delete(
      CensusList.dbName,
      where: 'id = ?',
      whereArgs: [censusList.id],
    );
    state = state.where((cl) => cl.id != censusList.id).toList();
    return true;
  }

  int indexOfCensusList(CensusList censusList) {
    return state.indexOf(censusList);
  }

  Future<void> insertCensusList(CensusList censusList, int index) async {
    final db = await DatabaseHelper().getCensusListDatabase();
    await db.update(
      CensusList.dbName,
      censusList.toMap(),
      where: 'id = ?',
      whereArgs: [censusList.id],
    );
    state = [censusList, ...state];
  }

  Future<CensusList?> findCensusListById(String id) async {
    final db = await DatabaseHelper().getCensusListDatabase();
    final data = await db.query(
      CensusList.dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isNotEmpty) return CensusList.fromMap(data.first);
    return null;
  }

  Future<void> updateCensusList(CensusList censusList) async {
    final db = await DatabaseHelper().getCensusListDatabase();
    await db.update(
      CensusList.dbName,
      censusList.toMap(),
      where: 'id = ?',
      whereArgs: [censusList.id],
    );
    final index = state.indexWhere((cl) => cl.id == censusList.id);
    List<CensusList> temp = state;
    temp[index] = censusList;
    state = [...state];
  }

  @override
  void dispose() async {
    await DatabaseHelper().closeDatabases();
    super.dispose();
  }
}

final censusListProvider =
    StateNotifierProvider<CensusListNotifier, List<CensusList>>(
  (ref) => CensusListNotifier(),
);
final filteredCensusListProvider = Provider<List<CensusList>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final items = ref.watch(censusListProvider);
  if (query.isEmpty) return items;
  return items.where((item) {
    final itemName = item.name.toLowerCase();
    return itemName == query;
  }).toList();
});
