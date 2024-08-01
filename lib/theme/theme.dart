import 'package:flutter/material.dart';

class Theme {
  ThemeData getThemeData(ColorScheme colorScheme) {
    return ThemeData().copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface, // AppBar postavljanje boje za ikone
        ),
      ),
      cardTheme: const CardTheme().copyWith(
        color: colorScheme.secondary,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSurface,
        ),
      ),
      textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
              fontSize: 14,
            ),
            bodyLarge: TextStyle(color: colorScheme.onSurface),
            bodyMedium: TextStyle(color: colorScheme.onSurface),
            bodySmall: TextStyle(color: colorScheme.onSurface),
          ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: colorScheme.onSurface, // Postavljanje boje za hint text
        ),
      ),
      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(
            color: colorScheme
                .onSurface), // Postavljanje boje za tekst u AlertDialog
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface, // Globalno postavljanje boje za ikone
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSurface,
        ),
      ),
    );
  }
}
