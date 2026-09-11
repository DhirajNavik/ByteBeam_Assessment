import 'package:flutter/material.dart';

class SnackbarTheme {
  SnackbarTheme._();

  static SnackBarThemeData from({required ColorScheme colorScheme}) {
    return SnackBarThemeData(
      actionTextColor: colorScheme.primary,
      actionBackgroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      contentTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
