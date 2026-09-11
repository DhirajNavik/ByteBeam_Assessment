import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get cardColor => theme.cardColor;
  ColorScheme get colorScheme => theme.colorScheme;
  Color get iconsColor => theme.colorScheme.onSurface;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  TextTheme get textTheme => theme.textTheme;
  InputDecorationThemeData  get textFieldTheme => theme.inputDecorationTheme;
}
