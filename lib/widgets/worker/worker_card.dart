import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/widgets/util/center_icon_text_row.dart';
import 'package:asset_manager/widgets/util/icon_text_row.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({
    super.key,
    required this.worker,
  });

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    void openOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => WorkerOverlay(
          worker: worker,
        ),
      );
    }

    return Card(
      child: ListTile(
        onTap: openOverlay,
        title: CenterRowIconText(
          icon: Icons.person_2,
          text: worker.fullName,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
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
          ),
        ),
      ),
    );
  }
}
