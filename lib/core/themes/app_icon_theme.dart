import 'package:flutter/material.dart';

class AppIconTheme {
  AppIconTheme._();

  static IconThemeData from(ColorScheme colorScheme) {
    return IconThemeData(color: colorScheme.onSurface);
  }
}
