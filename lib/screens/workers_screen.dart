import 'package:asset_manager/widgets/worker_overlay.dart';
import 'package:asset_manager/widgets/workers_list.dart';
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
    Worker(
        firstName: 'firstName0',
        lastName: 'lastName0',
        phoneNumber: '+38765123456',
        email: 'email0@email.com'),
    Worker(
        firstName: 'firstName1',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName2',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName3',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName4',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName5',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName6',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName7',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName8',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName9',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName10',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName11',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName0',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName1',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName2',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName3',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName4',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName5',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName6',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName7',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName8',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName9',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName10',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
    Worker(
        firstName: 'firstName11',
        lastName: 'lastName',
        phoneNumber: '+38765123456',
        email: 'email@email.com'),
  ];

  List<Worker>? _searchedWorkers;
  final _searchController = TextEditingController();
  void _searchWorkers(String query) {
    final searchedWorkers = _workers.where((worker) {
      final firstNameLower = worker.firstName.toLowerCase();
      final lastNameLower = worker.lastName.toLowerCase();
      final emailLower = worker.email.toLowerCase();
      final searchLower = query.toLowerCase();

      return firstNameLower.contains(searchLower) ||
          lastNameLower.contains(searchLower) ||
          emailLower.contains(searchLower);
    }).toList();

    setState(() {
      _searchedWorkers = searchedWorkers;
    });
  }

  void _openAddWorkerOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => WorkerOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedWorkers = _searchedWorkers ?? _workers;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 18.0),
          onChanged: _searchWorkers,
        ),
        actions: [
          IconButton(
            onPressed: _openAddWorkerOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: WorkersList(workers: displayedWorkers),
          ),
        ],
      ),
    );
  }
}
