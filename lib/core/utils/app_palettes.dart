import 'package:flutter/material.dart';

final class AppPalettes {
  AppPalettes._();

  // Brand

  static const primary = Color(0xFF05228A);
  static const onPrimary = Colors.white;
  static const primaryDark = Color(0xFF030F3D);
  static const secondary = Color(0xFF244BD5);

  // Text

  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);

  static const textPrimaryDark = Color(0xFFEFEFF0);
  static const textSecondaryDark = Color(0xFFDEDFE0);

  // Backgrounds

  static const backgroundLight = Color(0xFFF9F9F9);
  static const backgroundDark = Color(0xFF383737);

  // Container

  static const cardLight = Color(0xFFF3F4F6);
  static const cardDark = Color(0xFF2D2D2D);

  // BottomSheet

  static const bottomSheetLight = Color.fromARGB(255, 255, 255, 255);
  static const bottomSheetDark = Color.fromARGB(255, 32, 32, 32);

  // Status Colors

  static const success = Color(0xFF0A8236);
  static const error = Color(0xFFEF4444);

  // Neutral Colors

  static const white = Colors.white;
  static const black = Colors.black;

  static const grey = Color(0xFF9E9E9E);
  static const transparent = Colors.transparent;

  // Brand Gradient

  static const gradient = LinearGradient(
    colors: [Color(0xFF05228A), Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  //Divider Color
  static const lightDivide = Color.fromARGB(255, 226, 226, 226);
  static const darkDivider = Color.fromARGB(255, 233, 233, 233);

  //Calender color
  static const calendarActiveColor = Color(0xff369F27);
  static const calendarActiveLightColor = Color(0x80369F27);
  static const calendarBlockedLightColor = Color(0xffB60003);

  //Shadow
static const shadowLight = Color(0x14000000); // 8% black
static const shadowDark = Color(0x33000000);
}

extension ColorOpacityExtension on Color {
  Color withOpacityExt(double opacity) => withValues(alpha: opacity);
}
