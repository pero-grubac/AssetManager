import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';
import '../providers/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final isDarkMode = settings.themeMode == Settings.darkMode;

    // Define the list of languages with their display names and values
    final languageOptions = [
      {'name': Settings.engName, 'value': Settings.engLang},
      {'name': Settings.srbName, 'value': Settings.srbLang},
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.settingsScreenTitle),
      ),
      body: Center(
        child: Column(
          children: [
            // Dropdown for language selection
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.language,
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
                value: settings.language,
                items: languageOptions.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['value'],
                    child: Row(
                      children: [
                        Text(lang['name']!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .updateLanguage(value);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Switch for theme mode
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.theme),
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
