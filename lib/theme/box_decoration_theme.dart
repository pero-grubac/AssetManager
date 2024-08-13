import 'package:flutter/material.dart';

class CustomBoxDecorationTheme
    extends ThemeExtension<CustomBoxDecorationTheme> {
  final BoxDecoration boxDecoration;

  CustomBoxDecorationTheme({required this.boxDecoration});

  @override
  CustomBoxDecorationTheme copyWith({BoxDecoration? boxDecoration}) {
    return CustomBoxDecorationTheme(
      boxDecoration: boxDecoration ?? this.boxDecoration,
    );
  }

  @override
  CustomBoxDecorationTheme lerp(
      ThemeExtension<CustomBoxDecorationTheme>? other, double t) {
    if (other is! CustomBoxDecorationTheme) return this;
    return CustomBoxDecorationTheme(
      boxDecoration: BoxDecoration.lerp(boxDecoration, other.boxDecoration, t)!,
    );
  }
}
