import 'package:asset_manager/widgets/worker_card.dart';
import 'package:flutter/material.dart';

import '../models/worker.dart';

class WorkersList extends StatelessWidget {
  const WorkersList(
      {super.key, required this.workers, required this.onRemoveWorker});
  final List<Worker> workers;
  final void Function(Worker worker) onRemoveWorker;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workers.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(workers[index]),
        onDismissed: (direction) {
          onRemoveWorker(workers[index]);
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: Theme.of(context).cardTheme.margin,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: WorkerCard(worker: workers[index]),
      ),
    );
  }
}
