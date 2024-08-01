import 'package:flutter/material.dart';

const primaryColor = Color(0xFFEE4488);
const complementaryColor = Color(0xFF44EEAA);
const errorColor = Color(0xFFEE5544);

var kColorScheme = ColorScheme(
  primary: primaryColor,
  primaryContainer: primaryColor.withOpacity(0.8),
  secondary: complementaryColor,
  secondaryContainer: complementaryColor.withOpacity(0.8),
  surface: Colors.white,
  error: errorColor,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);
const darkPrimaryColor = Color(0xFF0088DA);
const darkComplementaryColor = Color(0xFFDA5400);
const darkTriadicColor1 = Color(0xFF5400DA);

var kDarkColorScheme = ColorScheme(
  primary: darkPrimaryColor,
  primaryContainer: darkPrimaryColor.withOpacity(0.8),
  secondary: darkComplementaryColor,
  secondaryContainer: darkComplementaryColor.withOpacity(0.8),
  surface: const Color(0xFF1E1E1E),
  error: errorColor,
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onError: Colors.black,
  brightness: Brightness.dark,
);

var lightTheme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  scaffoldBackgroundColor: kColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primary,
    foregroundColor: kColorScheme.onPrimary,
    iconTheme: IconThemeData(
      color: kColorScheme.onPrimary, // AppBar postavljanje boje za ikone
    ),
  ),
  cardTheme: const CardTheme().copyWith(
    color: kColorScheme.secondaryContainer,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primary,
      foregroundColor: kColorScheme.onPrimary,
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: kColorScheme.onSurface,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(color: kColorScheme.onSurface),
        bodyMedium: TextStyle(color: kColorScheme.onSurface),
        bodySmall: TextStyle(color: kColorScheme.onSurface),
      ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: kColorScheme.onSurface
          .withOpacity(0.6), // Postavljanje boje za hint text
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: kColorScheme.surface,
    contentTextStyle: TextStyle(color: kColorScheme.onSurface),
    titleTextStyle: TextStyle(
      color: kColorScheme.onSurface, // Boja za naslov u AlertDialog
    ), // Postavljanje boje za tekst u AlertDialog
  ),
  iconTheme: IconThemeData(
    color: kColorScheme.onSurface, // Globalno postavljanje boje za ikone
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: kColorScheme.primary,
      foregroundColor: kColorScheme.onPrimary,
    ),
  ),
);
var darkTheme = ThemeData().copyWith(
  colorScheme: kDarkColorScheme,
  scaffoldBackgroundColor: kDarkColorScheme.surface,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primary,
    foregroundColor: kDarkColorScheme.onPrimary,
    iconTheme: IconThemeData(
      color: kDarkColorScheme.onPrimary, // AppBar postavljanje boje za ikone
    ),
  ),
  cardTheme: const CardTheme().copyWith(
    color: kDarkColorScheme.secondaryContainer, // Boja za kartice
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primary, // Pozadina dugmeta
      foregroundColor: kDarkColorScheme.onPrimary, // Tekst na dugmetu
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: kDarkColorScheme.primary,
      foregroundColor: kDarkColorScheme.onPrimary, // Boja teksta na dugmetu
    ),
  ),
  textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: kDarkColorScheme.onSurface,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(color: kDarkColorScheme.onSurface),
        bodyMedium: TextStyle(color: kDarkColorScheme.onSurface),
        bodySmall: TextStyle(color: kDarkColorScheme.onSurface),
      ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: kDarkColorScheme.onSurface.withOpacity(0.6), // Boja za hint tekst
    ),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: kDarkColorScheme.surface,
    contentTextStyle: TextStyle(
      color: kDarkColorScheme.onSurface, // Boja za tekst u AlertDialog
    ),
    titleTextStyle: TextStyle(
      color: kDarkColorScheme.onSurface, // Boja za naslov u AlertDialog
    ),
  ),
  iconTheme: IconThemeData(
    color: kDarkColorScheme.onSurface, // Globalno postavljanje boje za ikone
  ),
);
