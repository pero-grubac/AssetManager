import 'package:asset_manager/models/worker.dart';
import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key, required this.worker});
  final Worker worker;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_2),
                const SizedBox(width: 8),
                Text(worker.fullName),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 8),
                    Text(worker.email),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Text(worker.phoneNumber),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
