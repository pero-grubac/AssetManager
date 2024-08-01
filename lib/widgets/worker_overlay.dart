import 'package:flutter/material.dart';

import '../models/worker.dart';

class WorkerOverlay extends StatefulWidget {
  const WorkerOverlay({super.key, required this.onAddWorker});
  final void Function(Worker worker) onAddWorker;
  @override
  State<WorkerOverlay> createState() => _WorkerOverlayState();
}

class _WorkerOverlayState extends State<WorkerOverlay> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(
      r'^\+?[0-9]{7,15}$',
    );
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
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
    final enteredEmail = _emailNameController.text.trim();
    final enteredPhone = _phoneController.text.trim();

    if (enteredFirstName.isEmpty) {
      _showErrorDialog('First name is required');
      return;
    }

    if (enteredLastName.isEmpty) {
      _showErrorDialog('Last name is required');
      return;
    }

    if (enteredEmail.isEmpty || !_isValidEmail(enteredEmail)) {
      _showErrorDialog('Please enter a valid email address');
      return;
    }

    if (enteredPhone.isEmpty || !_isValidPhoneNumber(enteredPhone)) {
      _showErrorDialog('Please enter a valid phone number');
      return;
    }
    widget.onAddWorker(Worker(
      firstName: enteredFirstName,
      lastName: enteredLastName,
      phoneNumber: enteredPhone,
      email: enteredEmail,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              label: Text('First name'),
            ),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              label: Text('Last name'),
            ),
          ),
          TextField(
            controller: _emailNameController,
            decoration: const InputDecoration(
              label: Text('Email'),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              label: Text('Phone number'),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Save'),
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
