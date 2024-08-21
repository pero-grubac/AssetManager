import 'dart:ui';

import 'package:asset_manager/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/settings.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale locale) : super(locale);

  void updateLocale(Locale locale) {
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final settings = ref.read(settingsNotifierProvider);
  final locale = Locale(settings.language == Settings.engLang ? 'en' : 'sr');
  return LocaleNotifier(locale);
});
