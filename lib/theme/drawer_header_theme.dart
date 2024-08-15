import 'package:flutter/material.dart';

class DrawerHeaderTheme extends ThemeExtension<DrawerHeaderTheme> {
  final BoxDecoration? drawerHeaderDecoration;
  DrawerHeaderTheme({this.drawerHeaderDecoration});

  @override
  DrawerHeaderTheme copyWith({
    BoxDecoration? drawerHeaderDecoration,
  }) {
    return DrawerHeaderTheme(
      drawerHeaderDecoration:
          drawerHeaderDecoration ?? this.drawerHeaderDecoration,
    );
  }

  @override
  DrawerHeaderTheme lerp(ThemeExtension<DrawerHeaderTheme>? other, double t) {
    if (other is! DrawerHeaderTheme) {
      return this;
    }
    return DrawerHeaderTheme(
      drawerHeaderDecoration: BoxDecoration.lerp(
        drawerHeaderDecoration,
        other.drawerHeaderDecoration,
        t,
      ),
    );
  }
}
