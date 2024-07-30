import 'package:asset_manager/widgets/worker_card.dart';
import 'package:flutter/material.dart';

import '../models/worker.dart';

class WorkersList extends StatelessWidget {
  const WorkersList({super.key, required this.workers});
  final List<Worker> workers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workers.length,
      itemBuilder: (context, index) => WorkerCard(worker: workers[index]),
    );
  }
}
