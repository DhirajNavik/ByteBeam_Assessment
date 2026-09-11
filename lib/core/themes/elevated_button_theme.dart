import 'package:flutter/material.dart';

import '../utils/dimens.dart';

final class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData from({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, Dimens.buttonHeight),
        maximumSize: Size(double.infinity, Dimens.buttonHeight),
        padding: .all(Dimens.buttonPadding),
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.outline,
        disabledForegroundColor: colorScheme.onPrimary,
        textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: .circular(Dimens.buttonRadius),
        ),
      ),
    );
  }
}
