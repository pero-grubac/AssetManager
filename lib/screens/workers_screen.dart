import 'package:asset_manager/providers/worker_provider.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/worker.dart';
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
  final List<Worker> _workers = [
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
  ];

  List<Worker>? _searchedWorkers;
  final _searchController = TextEditingController();
  void _searchWorkers(String query) {
    final searchLower = query.toLowerCase();
    final searchedWorkers = _workers.where((worker) {
      final firstNameLower = worker.firstName.toLowerCase();
      final lastNameLower = worker.lastName.toLowerCase();
      final emailLower = worker.email.toLowerCase();

      return firstNameLower.contains(searchLower) ||
          lastNameLower.contains(searchLower) ||
          emailLower.contains(searchLower);
    }).toList();

    setState(() {
      _searchedWorkers = searchedWorkers;
    });
  }

  void _addWorker(Worker worker) {
    ref.read(workerProvider.notifier).addWorker(worker);
  }

  void _removeWorker(Worker worker) {
    final workerIndex = _workers.indexOf(worker);
    setState(() {
      // TODO
      _workers.remove(worker);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Worker deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              // TODO
              _workers.insert(workerIndex, worker);
            });
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
          setState(() {
            // TODO
            final index = _workers.indexOf(worker);
            _workers[index] = updatedWorker;
            _searchedWorkers = null;
          });
        },
        worker: worker,
      ),
    );
  }

  void openOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => WorkerOverlay(
        onSaveWorker: _addWorker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedWorkers = _searchedWorkers ?? _workers;

    Widget mainContent = const Center(
      child: Text('No workers found.'),
    );
    if (displayedWorkers.isNotEmpty) {
      mainContent = DismissibleList<Worker>(
        //  items: displayedWorkers,
        onRemoveItem: _removeWorker,
        onEditItem: _editWorker,
        itemBuilder: (context, worker) => WorkerCard(
          worker: worker,
        ),
        isEditable: true,
        provider: workerProvider,
      );
    }
    return Screen(
      searchController: _searchController,
      onSearchChanged: _searchWorkers,
      body: mainContent,
      overlay: WorkerOverlay(
        onSaveWorker: _addWorker,
      ),
    );
  }
}
