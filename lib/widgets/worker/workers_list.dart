import 'package:flutter/material.dart';
import '../../models/worker.dart';
import 'worker_card.dart';
import '../dismissible_list.dart';

class WorkersList extends StatelessWidget {
  const WorkersList({
    super.key,
    required this.workers,
    required this.onRemoveWorker,
  });

  final List<Worker> workers;
  final void Function(Worker worker) onRemoveWorker;

  @override
  Widget build(BuildContext context) {
    return DismissibleList<Worker>(
      items: workers,
      onRemoveItem: onRemoveWorker,
      itemBuilder: (context, worker) => WorkerCard(worker: worker),
    );
  }
}
