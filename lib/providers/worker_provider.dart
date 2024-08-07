import 'package:asset_manager/models/worker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkerNotifier extends StateNotifier<List<Worker>> {
  WorkerNotifier()
      : super([
          Worker(
              firstName: 'firstName0',
              lastName: 'lastName0',
              phoneNumber: '+38765123456',
              email: 'email0@email.com'),
          Worker(
            firstName: 'firstName1',
            lastName: 'lastName1',
            phoneNumber: '+38765123456',
            email: 'email1@email.com',
          ),
        ]);
  void addWorker(Worker worker) {
    state = [worker, ...state];
  }
}

final workerProvider = StateNotifierProvider<WorkerNotifier, List<Worker>>(
  (ref) => WorkerNotifier(),
);
