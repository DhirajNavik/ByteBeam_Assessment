import 'package:flutter/material.dart';
import '../utils/dimens.dart';

class AppNavigationTheme {
  AppNavigationTheme._();

  static NavigationBarThemeData from({required ColorScheme colorScheme}) {
    return NavigationBarThemeData(
      shadowColor: colorScheme.shadow,
      backgroundColor: colorScheme.primary,
      surfaceTintColor: Colors.transparent,
      elevation: Dimens.elevation,
    );
  }
}
