import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';
import '../providers/settings_provider.dart';

// ThemeNotifier that controls the current theme mode
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(super.initialTheme);

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
  }
}

// themeNotifierProvider that provides access to ThemeNotifier
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) {
    // Get the initial theme mode from SettingsNotifier
    final settings = ref.read(settingsNotifierProvider);
    final initialThemeMode = settings.themeMode == Settings.darkMode
        ? ThemeMode.dark
        : ThemeMode.light;

    return ThemeNotifier(initialThemeMode);
  },
);
