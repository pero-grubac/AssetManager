import 'package:asset_manager/theme/theme.dart';
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

var lightTheme = AppTheme().getThemeData(kColorScheme);

var darkTheme = AppTheme().getThemeData(kDarkColorScheme);
