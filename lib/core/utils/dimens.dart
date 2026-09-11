import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  Dimens._();

  static const padding = 0.0;

  // Horizontal Padding
  static double get horPaddingX1 => 4.w;
  static double get horPaddingX2 => 8.w;
  static double get horPaddingX3 => 12.w;
  static double get horPaddingX4 => 16.w;
  static double get horPaddingX5 => 20.w;

  // Vertical Padding
  static double get verPaddingX1 => 4.h;
  static double get verPaddingX2 => 8.h;
  static double get verPaddingX3 => 12.h;
  static double get verPaddingX4 => 16.h;
  static double get verPaddingX4B => 18.h;
  static double get verPaddingX5 => 20.h;

  // All Padding
  static double get allPaddingX => 2.r;
  static double get allPaddingX1 => 4.r;
  static double get allPaddingX1B => 6.r;
  static double get allPaddingX2 => 8.r;
  static double get allPaddingX2B => 10.r;
  static double get allPaddingX3 => 12.r;
  static double get allPaddingX3B => 14.r;
  static double get allPaddingX4 => 16.r;
  static double get allPaddingX5 => 20.r;
  static double get allPaddingX6 => 24.r;
  static double get allPaddingX7 => 28.r;
  static double get allPaddingX8 => 32.0.r;
  static double get allPaddingX25 => 100.0.r;

  static double get horizontalspacing => 20.r;
  static double get verticalspacing => 20.r;

  static double radius = 0;

  static double get radiusX => 2.r;
  static double get radiusX1 => 4.r;
  static double get radiusX2 => 8.r;
  static double get radiusX3 => 12.r;
  static double get radiusX4 => 16.r;
  static double get radiusX5 => 20.r;
  static double get radiusX6 => 24.r;
  static double get radiusX7 => 28.r;
  static double get radiusX8 => 32.r;
  static double get radiusX9 => 36.r;
  static double get radiusX10 => 40.r;
  static double get radiusX14 => 56.r;
  static double get radius100 => 100.r;

  //margin
  static const margin = 0.0;

  static double get allMarginX1 => 4.0.r;
  static double get allMarginX2 => 8.0.r;
  static double get allMarginX6 => 24.0.r;

  //standard scales
  static const scale = 0.0;

  static double get scaleX => 4.0.r;
  static double get scaleXB => 6.0.r;
  static double get scaleX1 => 8.0.r;
  static double get scaleX1B => 14.0.r;
  static double get scaleX2 => 16.0.r;
  static double get scaleX2B => 20.0.r;
  static double get scaleX3 => 24.0.r;
  static double get scaleX3B => 28.0.r;
  static double get scaleX4 => 32.0.r;
  static double get scaleX4B => 36.0.r;
  static double get scaleX5 => 40.0.r;
  static double get scaleX6 => 48.0.r;
  static double get scaleX7 => 56.0.r;
  static double get scaleX8 => 64.0.r;
  static double get scaleX9 => 72.0.r;
  static double get scaleX10 => 80.0.r;
  static double get scaleX15 => 120.0.r;
  static double get scaleX20 => 160.0.r;
  static double get scaleX25 => 200.0.r;
  static double get scale50 => 50.0.r;

  //dividers
  static const gap = 0.0;

  static double get gapX => 2.0.r;
  static double get gapX1 => 4.0.r;
  static double get gapX1B => 6.0.r;
  static double get gapX2 => 8.0.r;
  static double get gapX2B => 10.0.r;
  static double get gapX3 => 12.0.r;
  static double get gapX4 => 16.0.r;
  static double get gapX5 => 20.0.r;
  static double get gapX6 => 24.0.r;
  static double get gapX7 => 28.0.r;
  static double get gapX8 => 32.0.r;
  static double get gapX9 => 36.0.r;
  static double get gapX10 => 40.0.r;

  static double get screenWidth => 1.sw;
  static double get screenHalfWidth => 0.5.sw;
  static double get screenHeight => 1.sh;
  static double get screenHalfHeight => 0.5.sh;
  static double get textFromSpacing => 12.r;
  static double get widgetSpacing => 14.r;
  static double get borderWidth => 1.w;

  static const elevation = 2.0;
  static double get appBarSpacing => 10.r;
  static double get appBarHeight => 60.r;
  static double get extendAppBarHeight => 100.r;
  static double get buttonHeight => 50.h;
  static double get cardButtonHeight => 30.h;
  static double get buttonPadding => 12.r;
  static double get buttonRadius => 12.r;
  static double get cardRadius => 12.r;
  static double get checkboxRadius => 4.r;
  static double get bottomSheetRadius => 16.r;
  static double get addButtonHeight => 30.h;
  static double get buttonHeightSpacing => 90.h;
  static double get navBarHeight => 75.h;
  static double get navBarSpacingHeight => 110.h;

  static bool get isTablet => screenWidth > 600 ? true : false;

}
