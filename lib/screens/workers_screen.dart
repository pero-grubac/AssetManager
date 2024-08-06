import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';

import '../models/worker.dart';
import '../screens/screen.dart';
import '../widgets/dismissible_list.dart';
import '../widgets/worker/worker_card.dart';

class WorkersScreen extends StatefulWidget {
  static const id = 'workers_screen';
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
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
        email: 'email1@email.com'),
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
    setState(() {
      _searchedWorkers = null;
      _workers.insert(0, worker);
    });
  }

  void _removeWorker(Worker worker) {
    final workerIndex = _workers.indexOf(worker);
    setState(() {
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
            final index = _workers.indexOf(worker);
            _workers[index] = updatedWorker;
            _searchedWorkers = null; // Reset search results to show all workers
          });
        },
        worker: worker,
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
        items: displayedWorkers,
        onRemoveItem: _removeWorker,
        onEditItem: _editWorker,
        itemBuilder: (context, worker) => WorkerCard(worker: worker),
        isEditable: true,
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
