import 'package:asset_manager/models/worker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerNotifier extends StateNotifier<List<Worker>> {
  WorkerNotifier() : super(const []);
  void addWorker(Worker worker) {
    state = [worker, ...state];
  }
}

final workerProvider = StateNotifierProvider<WorkerNotifier, List<Worker>>(
  (ref) => WorkerNotifier(),
);
