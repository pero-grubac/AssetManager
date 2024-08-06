import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/widgets/util/center_icon_text_row.dart';
import 'package:flutter/material.dart';

import '../util/icon_text_row.dart';

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
            CenterRowIconText(
              icon: Icons.person_2,
              text: worker.fullName,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                IconTextRow(
                  icon: Icons.email,
                  text: worker.email,
                ),
                const Spacer(),
                IconTextRow(
                  icon: Icons.phone,
                  text: worker.phoneNumber,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
