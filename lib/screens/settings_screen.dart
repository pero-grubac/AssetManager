import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final isDarkMode = settings.themeMode == Settings.darkMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Language'),
            SwitchListTile(
              title: const Text('Theme'),
              value: isDarkMode,
              activeColor: Theme.of(context).colorScheme.secondary,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                final themeMode =
                    value ? Settings.darkMode : Settings.lightMode;
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateThemeMode(themeMode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
