import '../utils/dimens.dart';
import 'package:flutter/material.dart';

class AppBottomSheetTheme {
  AppBottomSheetTheme._();

  static BottomSheetThemeData from(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      showDragHandle: true,
      dragHandleColor: colorScheme.outlineVariant,
      backgroundColor: colorScheme.surfaceContainerHigh,
      modalBackgroundColor: colorScheme.surfaceContainerHigh,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.bottomSheetRadius),
      ),
    );
  }
}
