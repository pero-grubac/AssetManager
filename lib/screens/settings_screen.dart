import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Language'),
            Text('Theme'),
          ],
        ),
      ),
    );
  }
}
