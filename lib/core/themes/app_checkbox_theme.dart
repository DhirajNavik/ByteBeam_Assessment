import '../utils/dimens.dart';
import 'package:flutter/material.dart';

final class AppCheckboxTheme {
  AppCheckboxTheme._();

  static CheckboxThemeData from({required ColorScheme colorScheme}) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.checkboxRadius),
      ),
      side: BorderSide(color: colorScheme.outline, width: 1.5),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.outline.withValues(alpha: .4);
        }

        if (states.contains(WidgetState.selected)) {
          return colorScheme.inversePrimary;
        }

        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onInverseSurface),
    );
  }
}
