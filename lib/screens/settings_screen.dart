import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';
import '../providers/locale_provider.dart';
import '../providers/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  static const id = 'settings_screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final isDarkMode = settings.themeMode == Settings.darkMode;

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
                value: languageOptions
                        .any((lang) => lang['value'] == settings.language)
                    ? settings.language
                    : languageOptions.first['value'],
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
                    ref.read(localeProvider.notifier).updateLocale(
                        Locale(value == Settings.engLang ? 'en' : 'sr'));
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
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
