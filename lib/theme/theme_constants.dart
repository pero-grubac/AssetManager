import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 196, 59, 181),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 6, 79, 101),
);

var lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  scaffoldBackgroundColor: kColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.onPrimaryContainer,
    foregroundColor: kColorScheme.primaryContainer,
  ),
  cardTheme: const CardTheme().copyWith(
    color: kColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: kColorScheme.primaryContainer,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(color: kColorScheme.onSecondaryContainer),
        bodyMedium: TextStyle(color: kColorScheme.onSecondaryContainer),
        bodySmall: TextStyle(color: kColorScheme.onSecondaryContainer),
      ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: kColorScheme.primaryContainer, // Postavljanje boje za hint text
    ),
  ),
);
var darkTheme = ThemeData().copyWith(
  colorScheme: kDarkColorScheme,
  scaffoldBackgroundColor: kDarkColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primaryContainer,
    foregroundColor: kDarkColorScheme.onPrimaryContainer,
  ),
  cardTheme: const CardTheme().copyWith(
    color: kDarkColorScheme.primaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: kDarkColorScheme.onPrimaryContainer,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(color: kDarkColorScheme.onPrimaryContainer),
        bodyMedium: TextStyle(
            color: kDarkColorScheme.onSecondaryContainer, fontSize: 14),
        bodySmall: TextStyle(color: kDarkColorScheme.onSecondaryContainer),
      ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color:
          kDarkColorScheme.onPrimaryContainer, // Postavljanje boje za hint text
    ),
  ),
);
