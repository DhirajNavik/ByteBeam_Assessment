import 'dart:async';

import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:flutter/material.dart';

class CommonSnackbar {
  static CommonSnackbar? _instance;
  const CommonSnackbar._();

  factory CommonSnackbar() {
    _instance ??= CommonSnackbar._();
    return _instance!;
  }

  static void showUndoToast(
    BuildContext context, {
    required String message,
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.removeCurrentSnackBar();
    final controller = messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.horPaddingX5,
          vertical: Dimens.verPaddingX1,
        ).copyWith(right: Dimens.horPaddingX1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusX3),
        ),
        elevation: 6,
        action: SnackBarAction(label: 'UNDO', onPressed: onUndo),
      ),
    );
    Future.delayed(duration, () {
      controller.closed
          .then((_) {
            return ;
          })
          .timeout(
            Duration(seconds: 1),
            onTimeout: () {
              controller.close();
            },
          );
    });
  }
}
