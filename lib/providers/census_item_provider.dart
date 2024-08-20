import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/providers/database.dart';
import 'package:asset_manager/providers/util_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CensusItemNotifier extends StateNotifier<List<CensusItem>> {
  CensusItemNotifier() : super(const []);
  Future<void> loadItems() async {
    final db = await DatabaseHelper().getCensusItemDatabase();
    final data = await db.query(
      CensusItem.dbName,
      orderBy: 'createdAt DESC',
    );
    final items = data.map((row) => CensusItem.fromMap(row)).toList();
    state = items;
  }

  Future<void> addCensusItem(CensusItem censusItem) async {
    final db = await DatabaseHelper().getCensusItemDatabase();
    final ci = await findCensusItemById(censusItem.id);
    final existingItems = await db.query(
      CensusItem.dbName,
      where: 'censusListId = ? AND assetId = ?',
      whereArgs: [censusItem.censusListId, censusItem.assetId],
    );
    if (existingItems.isNotEmpty) return;
    if (ci == null) {
      await db.insert(
        CensusItem.dbName,
        censusItem.toMap(),
      );
      state = [censusItem, ...state];
    }
  }

  Future<void> removeCensusItem(CensusItem censusItem) async {
    final db = await DatabaseHelper().getCensusItemDatabase();
    await db.delete(
      censusItem.id,
      where: 'id = ?',
      whereArgs: [censusItem.id],
    );
    state = state.where((ci) => ci.id != censusItem.id).toList();
  }

  int indexOfCensusItem(CensusItem censusItem) {
    return state.indexOf(censusItem);
  }

  Future<void> insertCensusItem(CensusItem censusItem, int index) async {
    final db = await DatabaseHelper().getCensusItemDatabase();
    await db.update(
      CensusItem.dbName,
      censusItem.toMap(),
      where: 'id = ?',
      whereArgs: [censusItem.id],
    );
    state = [censusItem, ...state];
  }

  Future<CensusItem?> findCensusItemById(String id) async {
    final db = await DatabaseHelper().getCensusItemDatabase();
    final data = await db.query(
      CensusItem.dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isNotEmpty) return CensusItem.fromMap(data.first);
    return null;
  }

  @override
  void dispose() async {
    await DatabaseHelper().closeDatabases();
    super.dispose();
  }
}

final censusItemProvider =
    StateNotifierProvider<CensusItemNotifier, List<CensusItem>>(
  (ref) => CensusItemNotifier(),
);
final filteredCensusItemProvider = Provider<List<CensusItem>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final id = ref.watch(censusListIdProvider).toLowerCase();
  final items = ref.watch(censusItemProvider);
  if (query.isEmpty || id.isEmpty) return items;
  return items.where((censusItem) {
    bool matchesId = id == censusItem.censusListId;
    //TODO add searching by something like worker/location
    return matchesId;
  }).toList();
});
