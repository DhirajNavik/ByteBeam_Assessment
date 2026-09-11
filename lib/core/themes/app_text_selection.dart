import 'package:flutter/material.dart';

class AppTextSelection {
  AppTextSelection._();

  static TextSelectionThemeData from(ColorScheme colorScheme) {
    return TextSelectionThemeData(
      cursorColor: colorScheme.primary,
      selectionColor: colorScheme.primary.withValues(alpha: .25),
      selectionHandleColor: colorScheme.primary,
    );
  }
}
