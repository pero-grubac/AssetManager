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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Workers'),
          Expanded(
            child: WorkersList(workers: _workers),
          ),
        ],
      ),
    );
  }
}
