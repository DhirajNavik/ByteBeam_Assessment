import 'package:flutter/material.dart';
import '../utils/dimens.dart';

class AppBarThemes {
  AppBarThemes._();

  static AppBarTheme from({
    required ColorScheme colorScheme,
    required TextStyle? titleTextStyle,
  }) {
    return AppBarTheme(
      toolbarHeight: Dimens.appBarHeight,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      titleTextStyle: titleTextStyle?.copyWith(color: colorScheme.onPrimary),
      actionsIconTheme: IconThemeData(color: colorScheme.onPrimary),
      surfaceTintColor: colorScheme.primary,
      shadowColor: colorScheme.primary,
      elevation: 0,

      scrolledUnderElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(Dimens.radiusX8, Dimens.radiusX6),
        ),
      ),
    );
  }
}
