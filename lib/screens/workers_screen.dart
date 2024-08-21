import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/worker.dart';
import '../providers/util_provider.dart';
import '../screens/screen.dart';
import '../widgets/util/centered_circular_loading.dart';
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

  late Future<void> _workersFuture;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workersFuture = ref.read(workerProvider.notifier).loadItems();
  }

  void setIsLoading(bool load) {
    setState(() {
      _isLoading = load;
    });
  }

  void _searchWorkers(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _addWorker(Worker worker) async {
    setIsLoading(true);
    await ref.read(workerProvider.notifier).addWorker(worker);
    setIsLoading(false);
  }

  Future<void> _removeWorker(Worker worker) async {
    final workerNotifier = ref.read(workerProvider.notifier);

    final shouldDelete = await workerNotifier.removeWorker(worker);

    _showUndoSnackBar(worker, shouldDelete);
  }

  void _showUndoSnackBar(Worker worker, bool shouldDelete) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (shouldDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('Location deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setIsLoading(true);
              await ref.read(workerProvider.notifier).addWorker(worker);
              setIsLoading(false);
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Worker can not be deleted.'),
      ));
    }
  }

  Future<void> _editWorker(Worker worker) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => WorkerOverlay(
        onSaveWorker: (updatedWorker) {
          setIsLoading(true);
          ref.read(workerProvider.notifier).updateWorker(updatedWorker);
          setIsLoading(false);
        },
        worker: worker,
      ),
    );
  }

  void _onIconPressed() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: WorkerOverlay(
            onSaveWorker: _addWorker,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Screen(
          searchController: _searchController,
          onSearchChanged: _searchWorkers,
          body: DismissibleList<Worker>(
            onRemoveItem: _removeWorker,
            onEditItem: _editWorker,
            itemBuilder: (context, worker) => WorkerCard(
              isSelectable: false,
              worker: worker,
            ),
            isEditable: true,
            provider: filteredWorkersProvider,
            emptyMessage: 'No workers found.',
          ),
          onIconPressed: _onIconPressed,
        ),
        if (_isLoading)
          const CenteredCircularLoading(), // Overlay a loading indicator during operations
      ],
    );
  }
}
