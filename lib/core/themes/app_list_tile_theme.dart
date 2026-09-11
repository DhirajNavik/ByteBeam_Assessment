import 'package:flutter/material.dart';

class AppListTileTheme {
  AppListTileTheme._();

  static ListTileThemeData from({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ListTileThemeData(
      selectedTileColor: colorScheme.surface,
      textColor: colorScheme.onSurface,
      iconColor: colorScheme.onSurfaceVariant,
      leadingAndTrailingTextStyle: textTheme.titleMedium,
      titleTextStyle: textTheme.titleMedium,
      subtitleTextStyle: textTheme.bodyMedium,
      selectedColor: colorScheme.onSurface,
    );
  }
}
