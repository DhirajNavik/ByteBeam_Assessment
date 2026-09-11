import 'package:flutter/material.dart';

class AppBottomAppBarTheme {
  AppBottomAppBarTheme._();

  static BottomAppBarThemeData from({required ColorScheme colorScheme}) {
    return BottomAppBarThemeData(
      color: colorScheme.primary,
      surfaceTintColor: Colors.transparent,
      padding: .zero,
    );
  }
}
