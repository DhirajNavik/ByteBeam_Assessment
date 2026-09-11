import 'package:bytebeam_assessment/core/themes/snackbar_theme.dart';

import 'app_list_tile_theme.dart';
import 'app_navigation_theme.dart';
import 'app_progress_theme.dart';
import 'bottom_app_bar_theme.dart';
import 'package:flutter/material.dart';
import '../utils/app_palettes.dart';
import 'app_bottom_sheet_theme.dart';
import 'app_card_theme.dart';
import 'app_text_selection.dart';
import 'outline_button_theme.dart';
import 'app_action_icon_theme.dart';
import 'app_checkbox_theme.dart';
import 'app_icon_theme.dart';
import 'color_scheme.dart';
import 'app_bar_theme.dart';
import 'app_input_decor_theme.dart';
import 'app_text_theme.dart';
import 'elevated_button_theme.dart';
import 'app_divider_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const colorScheme = AppColorSchemes.light;
    final textTheme = AppTextTheme.from(colorScheme);
    return ThemeData(
      useMaterial3: true,
      brightness: .light,

      colorScheme: colorScheme,
      textTheme: textTheme,
      iconTheme: AppIconTheme.from(colorScheme),

      appBarTheme: AppBarThemes.from(
        colorScheme: colorScheme,
        titleTextStyle: textTheme.titleLarge,
      ),

      inputDecorationTheme: AppInputDecorationTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      textSelectionTheme: AppTextSelection.from(colorScheme),

      elevatedButtonTheme: AppElevatedButtonTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),

      outlinedButtonTheme: AppOutlinedButtonTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),

      cardTheme: AppCardTheme.from(colorScheme: colorScheme),
      bottomSheetTheme: AppBottomSheetTheme.from(colorScheme),
      checkboxTheme: AppCheckboxTheme.from(colorScheme: colorScheme),
      actionIconTheme: AppActionIconTheme.from(colorScheme: colorScheme),
      progressIndicatorTheme: AppProgressIndicatorThemeData.from(
        colorScheme: colorScheme,
      ),
      primaryColor: AppPalettes.primary,
      scaffoldBackgroundColor: colorScheme.surface,
      listTileTheme: AppListTileTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      dividerTheme: AppDividerTheme.from(colorScheme: colorScheme),
      bottomAppBarTheme: AppBottomAppBarTheme.from(colorScheme: colorScheme),
      navigationBarTheme: AppNavigationTheme.from(colorScheme: colorScheme),
      snackBarTheme: SnackbarTheme.from(colorScheme: colorScheme),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = AppColorSchemes.dark;
    final textTheme = AppTextTheme.from(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: colorScheme,
      textTheme: textTheme,
      iconTheme: AppIconTheme.from(colorScheme),

      appBarTheme: AppBarThemes.from(
        colorScheme: colorScheme,
        titleTextStyle: textTheme.titleLarge,
      ),

      inputDecorationTheme: AppInputDecorationTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      textSelectionTheme: AppTextSelection.from(colorScheme),

      elevatedButtonTheme: AppElevatedButtonTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),

      outlinedButtonTheme: AppOutlinedButtonTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
      progressIndicatorTheme: AppProgressIndicatorThemeData.from(
        colorScheme: colorScheme,
      ),
      cardTheme: AppCardTheme.from(colorScheme: colorScheme),
      bottomSheetTheme: AppBottomSheetTheme.from(colorScheme),
      checkboxTheme: AppCheckboxTheme.from(colorScheme: colorScheme),
      actionIconTheme: AppActionIconTheme.from(colorScheme: colorScheme),
      listTileTheme: AppListTileTheme.from(
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),

      dividerTheme: AppDividerTheme.from(colorScheme: colorScheme),
      bottomAppBarTheme: AppBottomAppBarTheme.from(colorScheme: colorScheme),
      navigationBarTheme: AppNavigationTheme.from(colorScheme: colorScheme),
      snackBarTheme: SnackbarTheme.from(colorScheme: colorScheme),
    );
  }
}
