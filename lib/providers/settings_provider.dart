import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';
import '../theme/theme_manager.dart';
import 'locale_provider.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  final Ref ref;

  SettingsNotifier(this.ref)
      : super(Settings(
            themeMode: Settings.lightMode, language: Settings.engLang)) {
    _loadSettings();
  }

  void updateThemeMode(String themeMode) {
    state = Settings(themeMode: themeMode, language: state.language);
    _saveSettings(); // Save settings after updating

    final themeModeEnum =
        themeMode == Settings.darkMode ? ThemeMode.dark : ThemeMode.light;
    ref.read(themeNotifierProvider.notifier).setTheme(themeModeEnum);
  }

  void updateLanguage(String language) {
    state = Settings(themeMode: state.themeMode, language: language);
    _saveSettings();

    final locale = Locale(language == Settings.engLang ? 'en' : 'sr');
    ref.read(localeProvider.notifier).updateLocale(locale);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('themeMode') ?? Settings.lightMode;
    final language = prefs.getString('language') ?? Settings.engLang;

    state = Settings(themeMode: themeMode, language: language);

    final themeModeEnum =
        themeMode == Settings.darkMode ? ThemeMode.dark : ThemeMode.light;
    ref.read(themeNotifierProvider.notifier).setTheme(themeModeEnum);

    final locale = Locale(language == Settings.engLang ? 'en' : 'sr');
    ref.read(localeProvider.notifier).updateLocale(locale);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', state.themeMode);
    await prefs.setString('language', state.language);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier(ref);
});
