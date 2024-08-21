import 'dart:convert';

class Settings {
  static const darkMode = 'dark';
  static const lightMode = 'light';

  static const engLang = 'english';
  static const engName = '🇺🇸  English';
  static const srbLang = 'serbian';
  static const srbName = '🇷🇸  Srpski';

  final String language;
  final String themeMode;
  Settings({required this.themeMode, required this.language});

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'themeMode': themeMode,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    final temp = map['themeMode'];
    final themeMode = temp == darkMode ? darkMode : lightMode;
    final l = map['language'];
    final language = l == engLang ? engLang : srbLang;
    return Settings(
      themeMode: themeMode,
      language: language,
    );
  }
  String toJson() => json.encode(toMap());
  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));
}
