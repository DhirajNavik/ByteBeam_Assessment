import 'package:flutter/material.dart';

import '../utils/dimens.dart';

final class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static OutlinedButtonThemeData from({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, Dimens.buttonHeight),
        padding: .all(Dimens.buttonPadding),
        elevation: 0,
        foregroundColor: colorScheme.onSurfaceVariant,
        textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        side: BorderSide(color: colorScheme.outline, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: .circular(Dimens.buttonRadius),
        ),
      ),
    );
  }
}
