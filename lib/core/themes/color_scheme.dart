import 'package:flutter/material.dart';
import '../utils/app_palettes.dart';

final class AppColorSchemes {
  AppColorSchemes._();

  static const light = ColorScheme.light(
    brightness: Brightness.light,
    // Brand
    primary: AppPalettes.primary,
    onPrimary: AppPalettes.onPrimary,

    secondary: AppPalettes.secondary,
    onSecondary: AppPalettes.white,

    // Checkbox
    inversePrimary: AppPalettes.primary,
    onInverseSurface: AppPalettes.white,

    // Surface
    surface: AppPalettes.backgroundLight,
    surfaceContainer: AppPalettes.cardLight,
    surfaceContainerHigh: AppPalettes.bottomSheetLight,

    onSurface: AppPalettes.textPrimary,
    onSurfaceVariant: AppPalettes.textSecondary,

    // Borders
    outline: AppPalettes.lightDivide,
    outlineVariant: AppPalettes.grey,

    error: AppPalettes.error,
    onError: AppPalettes.white,
    shadow: AppPalettes.shadowLight
  );

  static const dark = ColorScheme.dark(
    brightness: Brightness.dark,

    primary: AppPalettes.primaryDark,
    onPrimary: AppPalettes.onPrimary,

    secondary: AppPalettes.secondary,
    onSecondary: AppPalettes.white,

    inversePrimary: AppPalettes.white,
    onInverseSurface: AppPalettes.primary,

    surface: AppPalettes.backgroundDark,
    surfaceContainer: AppPalettes.cardDark,
    surfaceContainerHigh: AppPalettes.bottomSheetDark,
    surfaceTint: AppPalettes.bottomSheetDark,

    onSurface: AppPalettes.textPrimaryDark,
    onSurfaceVariant: AppPalettes.textSecondaryDark,
    
    outline: AppPalettes.darkDivider,
    outlineVariant: AppPalettes.white,

    error: AppPalettes.error,
    onError: AppPalettes.white,
    shadow: AppPalettes.shadowDark
  );
}
