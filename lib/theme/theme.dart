import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'box_decoration_theme.dart';

class AppTheme {
  ThemeData getThemeData(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface, // Icon color for AppBar
        ),
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(color: colorScheme.onSurface),
        bodyMedium: TextStyle(color: colorScheme.onSurface),
        bodySmall: TextStyle(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.6), // Hint text color
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface, // Dialog content text color
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface, // Dialog title text color
        ),
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface, // Global icon color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      extensions: [
        CustomBoxDecorationTheme(
          boxDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withOpacity(0.5),
                colorScheme.primary.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
