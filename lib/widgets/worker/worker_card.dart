import 'package:asset_manager/models/worker.dart';
import 'package:asset_manager/widgets/util/center_row_icon_widget.dart';
import 'package:asset_manager/widgets/util/row_icon_widget.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({
    super.key,
    required this.worker,
    this.onTap,
    this.isSelected = false,
    this.isSelectable = true,
  });

  final Worker worker;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isSelectable;
  @override
  Widget build(BuildContext context) {
    void openOverlay() {
      showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: WorkerOverlay(
              worker: worker,
              isEditable: false,
            ),
          );
        },
      );
    }

    return Card(
      child: ListTile(
        onTap: onTap ?? openOverlay,
        leading: isSelectable
            ? isSelected
                ? const Icon(Icons.check_circle)
                : const Icon(Icons.circle_outlined)
            : null,
        title: CenterRowIconText(
          icon: Icons.person_2,
          widget: Expanded(child: Text(worker.fullName)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              RowIconWidget(
                icon: Icons.email,
                widget: Text(worker.email),
              ),
              const Spacer(),
              RowIconWidget(
                icon: Icons.phone,
                widget: Text(worker.phoneNumber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
