import 'package:flutter/material.dart';

class WorkerOverlay extends StatefulWidget {
  const WorkerOverlay({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          const Spacer(),
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
                onPressed: () {},
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
