import 'package:asset_manager/widgets/worker_list.dart';
import 'package:flutter/material.dart';

import '../models/worker.dart';

class WorkersScreen extends StatefulWidget {
  static const id = 'workers_screen';
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  final List<Worker> _workers = [
    Worker(firstName: 'firstName0', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName1', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName2', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName3', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName4', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName5', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName6', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName7', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName8', lastName: 'lastName', position: 'position'),
    Worker(firstName: 'firstName9', lastName: 'lastName', position: 'position'),
    Worker(
        firstName: 'firstName10', lastName: 'lastName', position: 'position'),
    Worker(
        firstName: 'firstName11', lastName: 'lastName', position: 'position'),
    Worker(
        firstName: 'firstName12', lastName: 'lastName', position: 'position'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Workers'),
          Expanded(
            child: WorkerList(workers: _workers),
          ),
        ],
      ),
    );
  }
}
