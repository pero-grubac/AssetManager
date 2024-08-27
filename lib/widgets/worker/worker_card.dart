import 'package:asset_manager/models/worker.dart';
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
        title: RowIconWidget(
          icon: Icons.person_2,
          widget: Flexible(
              child: Text(
            worker.fullName,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              RowIconWidget(
                icon: Icons.email,
                widget: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    worker.email,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              RowIconWidget(
                icon: Icons.phone,
                widget: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    worker.phoneNumber,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
