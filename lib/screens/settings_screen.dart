import 'package:asset_manager/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

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
                ref.read(themeNotifierProvider.notifier).toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
