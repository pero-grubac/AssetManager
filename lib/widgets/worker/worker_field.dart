import 'package:asset_manager/widgets/util/helper_widgets.dart';
import 'package:asset_manager/widgets/worker/worker_card.dart';
import 'package:asset_manager/widgets/worker/worker_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/worker.dart';
import '../../providers/worker_provider.dart';
import '../../screens/selection_screen.dart';
import '../util/error_dialog.dart';

class WorkerField extends ConsumerStatefulWidget {
  const WorkerField({
    super.key,
    required this.isEditable,
    this.initialWorker,
    this.onWorkerSelected,
    required this.textFieldLabel,
    required this.controllerTextEmpty,
  });

  final bool isEditable;
  final Worker? initialWorker;
  final Function(Worker worker)? onWorkerSelected;
  final String textFieldLabel;
  final String controllerTextEmpty;
  @override
  ConsumerState<WorkerField> createState() => _WorkerFieldState();
}

class _WorkerFieldState extends ConsumerState<WorkerField> {
  final TextEditingController _newWorkerController = TextEditingController();
  Worker? _newWorker;

  @override
  void initState() {
    super.initState();
    if (widget.initialWorker != null) {
      _newWorkerController.text = widget.initialWorker!.fullName;
      _newWorker = widget.initialWorker;
    }
  }

  @override
  void dispose() {
    _newWorkerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _newWorkerController,
            decoration: InputDecoration(labelText: widget.textFieldLabel),
            readOnly: !widget.isEditable,
          ),
        ),
        addHorizontalSpace(8),
        if (widget.isEditable)
          IconButton(
            onPressed: _existingWorkers,
            icon: const Icon(Icons.supervised_user_circle),
          ),
        IconButton(
          onPressed: _showWorkerOverlay,
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }

  void _showWorkerOverlay() async {
    if (_newWorkerController.text.isEmpty) {
      ErrorDialog.show(context, widget.controllerTextEmpty);
    } else {
      List<String> parts = _newWorkerController.text.split(" ");
      _newWorker ??= await ref
          .read(workerProvider.notifier)
          .findWorkerByFullName(parts[0], parts[1]);

      if (_newWorker != null) {
        showDialog(
          context: context,
          builder: (ctx) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: WorkerOverlay(
                worker: _newWorker,
                isEditable: false,
              ),
            );
          },
        );
      } else {
        ErrorDialog.show(context, 'Worker does not exist.');
      }
    }
  }

  void _existingWorkers() async {
    setState(() {
      _newWorkerController.text = '';
    });
    final selectedWorker = await Navigator.push<Worker>(
      context,
      MaterialPageRoute(
        builder: (ctx) => SelectionScreen<Worker>(
          provider: workerProvider,
          onConfirmSelection: (selectedItem) {},
          cardBuilder: (Worker item, bool isSelected, void Function() onTap) {
            return WorkerCard(
              worker: item,
              onTap: onTap,
              isSelected: isSelected,
            );
          },
          title: 'Select worker',
          emptyMessage: 'No workers found',
        ),
      ),
    );
    if (selectedWorker != null) {
      setState(() {
        _newWorkerController.text = selectedWorker.fullName;
        _newWorker = selectedWorker;
      });
      if (widget.onWorkerSelected != null) {
        widget.onWorkerSelected!(selectedWorker);
      }
    }
  }
}
