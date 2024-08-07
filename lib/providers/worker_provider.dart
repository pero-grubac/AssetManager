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

  void searchWorker(String query) {
    List<Worker> results;
    if (query.isEmpty) {
      results = state;
    } else {
      final searchLower = query.toLowerCase();
      results = state.where((worker) {
        final firstNameLower = worker.firstName.toLowerCase();
        final lastNameLower = worker.lastName.toLowerCase();
        final emailLower = worker.email.toLowerCase();

        return firstNameLower.contains(searchLower) ||
            lastNameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();
    }
    state = results;
  }

  void removeWorker(Worker worker) {
    state = state.where((w) => w.id != worker.id).toList();
  }

  int indexOfWorker(Worker worker) {
    return state.indexOf(worker);
  }

  void insertWorker(Worker worker, int index) {
    final newList = [...state];
    newList.insert(index, worker);
    state = newList;
  }

  void updateWorker(Worker updatedWorker) {
    final index = state.indexWhere((worker) => worker.id == updatedWorker.id);
    List<Worker> temp = state;
    temp[index] = updatedWorker;
    state = [...temp];
  }
}

final workerProvider = StateNotifierProvider<WorkerNotifier, List<Worker>>(
  (ref) => WorkerNotifier(),
);
