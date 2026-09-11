import 'package:flutter/material.dart';
import '../utils/dimens.dart';

class AppDividerTheme {
  AppDividerTheme._();

  static DividerThemeData from({required ColorScheme colorScheme}) {
    return DividerThemeData(
      color: colorScheme.outline,
      radius: .circular(Dimens.radius100),
    );
  }
}
