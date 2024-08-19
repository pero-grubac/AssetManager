import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asset.dart';
import 'database.dart';

class WorkerNotifier extends StateNotifier<List<Worker>> {
  WorkerNotifier() : super(const []);

  Future<void> loadItems() async {
    final db = await DatabaseHelper().getWorkerDatabase();

    final data = await db.query(
      Worker.dbName,
      orderBy: 'createdAt DESC',
    );
    final workers = data.map((row) => Worker.fromMap(row)).toList();
    state = workers;
  }

  List<Worker> get allWorkers => state;

  Future<void> addWorker(Worker worker) async {
    final db = await DatabaseHelper().getWorkerDatabase();
    final w = await findWorkerById(worker.id);
    if (w == null) {
      db.insert(
        Worker.dbName,
        worker.toMap(),
      );
      state = [worker, ...state];
    }
  }

  Future<bool> removeWorker(Worker worker) async {
    final db = await DatabaseHelper().getWorkerDatabase();
    final assetDb = await DatabaseHelper().getAssetDatabase();

    final result = await assetDb.query(
      Asset.dbName,
      where: 'assignedPersonId = ?',
      whereArgs: [worker.id],
    );
    if (result.isNotEmpty) {
      return false;
    }
    await db.delete(
      Worker.dbName,
      where: 'id = ?',
      whereArgs: [worker.id],
    );
    state = state.where((w) => w.id != worker.id).toList();
    return true;
  }

  int indexOfWorker(Worker worker) {
    return state.indexOf(worker);
  }

  Future<void> insertWorker(Worker worker, int index) async {
    final db = await DatabaseHelper().getWorkerDatabase();
    await db.update(
      Worker.dbName,
      worker.toMap(),
      where: 'id = ?',
      whereArgs: [worker.id],
    );
    final newList = [...state];
    newList.insert(index, worker);
    state = newList;
  }

  Future<void> updateWorker(Worker updatedWorker) async {
    final db = await DatabaseHelper().getWorkerDatabase();
    await db.update(
      Worker.dbName,
      updatedWorker.toMap(),
      where: 'id = ?',
      whereArgs: [updatedWorker.id],
    );

    final index = state.indexWhere((worker) => worker.id == updatedWorker.id);
    List<Worker> temp = state;
    temp[index] = updatedWorker;
    state = [...temp];
  }

  Future<Worker?> findWorkerById(String id) async {
    final db = await DatabaseHelper().getWorkerDatabase();
    final data = await db.query(
      Worker.dbName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (data.isNotEmpty) {
      return Worker.fromMap(data.first);
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

final workerProvider = StateNotifierProvider<WorkerNotifier, List<Worker>>(
  (ref) => WorkerNotifier(),
);

final filteredWorkersProvider = Provider<List<Worker>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final workers = ref.watch(workerProvider);
  if (query.isEmpty) return workers;
  return workers.where((worker) {
    final firstNameLower = worker.firstName.toLowerCase();
    final lastNameLower = worker.lastName.toLowerCase();
    final emailLower = worker.email.toLowerCase();
    return firstNameLower.contains(query) ||
        lastNameLower.contains(query) ||
        emailLower.contains(query);
  }).toList();
});
