import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextStyle _baseStyle = TextStyle(
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextTheme from(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: _baseStyle.copyWith(
        fontSize: 34.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      displayMedium: _baseStyle.copyWith(
        fontSize: 30.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      displaySmall: _baseStyle.copyWith(
        fontSize: 26.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      headlineLarge: _baseStyle.copyWith(
        fontSize: 24.spMin,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineMedium: _baseStyle.copyWith(
        fontSize: 22.spMin,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: _baseStyle.copyWith(
        fontSize: 20.spMin,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: _baseStyle.copyWith(
        fontSize: 18.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleMedium: _baseStyle.copyWith(
        fontSize: 16.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      titleSmall: _baseStyle.copyWith(
        fontSize: 14.spMin,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      bodyLarge: _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      bodyMedium: _baseStyle.copyWith(
        fontSize: 14.spMin,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: _baseStyle.copyWith(
        fontSize: 12.spMin,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: _baseStyle.copyWith(
        fontSize: 14.spMin,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelMedium: _baseStyle.copyWith(
        fontSize: 12.spMin,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: _baseStyle.copyWith(
        fontSize: 10.spMin,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
