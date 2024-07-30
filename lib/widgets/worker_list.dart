import 'package:flutter/material.dart';

import '../models/worker.dart';

class WorkerList extends StatefulWidget {
  const WorkerList({super.key, required this.workers});
  final List<Worker> workers;

  @override
  State<WorkerList> createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.workers.length,
      itemBuilder: (context, index) => Text(widget.workers[index].firstName),
    );
  }
}
