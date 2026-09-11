import 'package:flutter/material.dart';

import '../utils/dimens.dart';

final class AppCardTheme {
  AppCardTheme._();

  static CardThemeData from({required ColorScheme colorScheme}) {
    return CardThemeData(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      margin: .zero,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(Dimens.cardRadius),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: .25),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
