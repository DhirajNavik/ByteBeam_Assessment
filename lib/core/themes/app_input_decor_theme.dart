import 'package:flutter/material.dart';

import '../utils/dimens.dart';

final class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  static InputDecorationTheme from({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return InputDecorationTheme(
      errorMaxLines: 3,
      filled: true,
      fillColor: colorScheme.surface,
      labelStyle: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      floatingLabelStyle: textTheme.bodyMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.error,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Dimens.allPaddingX4,
        horizontal: Dimens.allPaddingX3,
      ),
      border: _border(
        colorScheme.outline,
        radius: Dimens.radiusX2,
      ),
      enabledBorder: _border(
        colorScheme.outline,
        radius: Dimens.radiusX2,
      ),
      focusedBorder: _border(
        colorScheme.onSurface,
        radius: Dimens.radiusX2,
      ),
      errorBorder: _border(
        colorScheme.error.withValues(alpha: .2),
        radius: Dimens.radiusX2,
      ),
      focusedErrorBorder: _border(
        colorScheme.error,
        radius: Dimens.radiusX2,
      ),

    );
  }

  static OutlineInputBorder _border(
    Color color, {
    required double radius,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}