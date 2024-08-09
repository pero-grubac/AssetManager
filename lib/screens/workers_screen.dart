import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/worker.dart';
import '../providers/search_provider.dart';
import '../screens/screen.dart';
import '../widgets/util/dismissible_list.dart';
import '../widgets/worker/worker_card.dart';

class WorkersScreen extends ConsumerStatefulWidget {
  static const id = 'workers_screen';
  const WorkersScreen({super.key});

  @override
  ConsumerState<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends ConsumerState<WorkersScreen> {
  final _searchController = TextEditingController();

  void _searchWorkers(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  void _addWorker(Worker worker) {
    ref.read(workerProvider.notifier).addWorker(worker);
  }

  void _removeWorker(Worker worker) {
    final workerIndex = ref.read(workerProvider.notifier).indexOfWorker(worker);
    ref.read(workerProvider.notifier).removeWorker(worker);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(workerProvider.notifier).insertWorker(worker, workerIndex);
          },
        ),
      ),
    );
  }

  void _editWorker(Worker worker) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => WorkerOverlay(
        onSaveWorker: (updatedWorker) {
          ref.read(workerProvider.notifier).updateWorker(updatedWorker);
        },
        worker: worker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      searchController: _searchController,
      onSearchChanged: _searchWorkers,
      body: DismissibleList<Worker>(
        onRemoveItem: _removeWorker,
        onEditItem: _editWorker,
        itemBuilder: (context, worker) => WorkerCard(
          worker: worker,
        ),
        isEditable: true,
        provider: filteredWorkersProvider,
        emptyMessage: 'No workers found.',
      ),
      overlay: WorkerOverlay(
        onSaveWorker: _addWorker,
      ),
    );
  }
}
