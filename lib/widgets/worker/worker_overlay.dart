import 'package:asset_manager/widgets/util/build_text_field.dart';
import 'package:flutter/material.dart';
import '../../models/worker.dart';

class WorkerOverlay extends StatefulWidget {
  const WorkerOverlay({
    super.key,
    this.onSaveWorker,
    this.worker,
    this.isEditable = true,
  });
  final void Function(Worker worker)? onSaveWorker;
  final Worker? worker;
  final bool isEditable;
  @override
  State<WorkerOverlay> createState() => _WorkerOverlayState();
}

class _WorkerOverlayState extends State<WorkerOverlay> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      _firstNameController.text = widget.worker!.firstName;
      _lastNameController.text = widget.worker!.lastName;
      _emailController.text = widget.worker!.email;
      _phoneController.text = widget.worker!.phoneNumber;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _submitData() {
    final enteredFirstName = _firstNameController.text.trim();
    final enteredLastName = _lastNameController.text.trim();
    final enteredEmail = _emailController.text.trim();
    final enteredPhone = _phoneController.text.trim();
    try {
      Worker worker;
      if (widget.worker != null) {
        worker = Worker(
          id: widget.worker!.id,
          firstName: enteredFirstName,
          lastName: enteredLastName,
          phoneNumber: enteredPhone,
          email: enteredEmail,
        );
      } else {
        worker = Worker(
          firstName: enteredFirstName,
          lastName: enteredLastName,
          phoneNumber: enteredPhone,
          email: enteredEmail,
        );
      }

      widget.onSaveWorker!(worker);

      Navigator.pop(context);
    } catch (e) {
      if (e is ArgumentError) {
        _showErrorDialog(e.message);
      } else {
        _showErrorDialog('An unknown error occurred');
      }
    }
  }

  List<Widget> _buildTextFields({required bool isWideScreen}) {
    final firstNameWidget = BuildTextField(
      controller: _firstNameController,
      label: 'First name',
      isEditable: widget.isEditable,
    );
    final lastNameWidget = BuildTextField(
      controller: _lastNameController,
      label: 'Last name',
      isEditable: widget.isEditable,
    );
    final emailWidget = BuildTextField(
      controller: _emailController,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      isEditable: widget.isEditable,
    );
    final phoneWidget = BuildTextField(
      controller: _phoneController,
      label: 'Phone number',
      keyboardType: TextInputType.phone,
      isEditable: widget.isEditable,
    );

    if (isWideScreen) {
      return [
        Row(
          children: [
            Expanded(child: firstNameWidget),
            const SizedBox(width: 16),
            Expanded(child: lastNameWidget),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            Expanded(child: emailWidget),
            const SizedBox(width: 16),
            Expanded(child: phoneWidget),
          ],
        ),
      ];
    } else {
      return [
        firstNameWidget,
        lastNameWidget,
        emailWidget,
        phoneWidget,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardSpace),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildTextFields(isWideScreen: isWideScreen),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.onSaveWorker == null) const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      if (widget.onSaveWorker != null) const Spacer(),
                      if (widget.onSaveWorker != null)
                        ElevatedButton(
                          onPressed: _submitData,
                          child: const Text('Save'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
