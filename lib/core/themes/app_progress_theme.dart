import 'package:flutter/material.dart';
import '../utils/app_palettes.dart';
import '../utils/dimens.dart';

class AppProgressIndicatorThemeData {
  AppProgressIndicatorThemeData._();

  static ProgressIndicatorThemeData from({required ColorScheme colorScheme}) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      refreshBackgroundColor: colorScheme.primary.withOpacityExt(0.2),
      strokeWidth: Dimens.scaleXB,
      strokeCap: StrokeCap.round,
    );
  }
}
