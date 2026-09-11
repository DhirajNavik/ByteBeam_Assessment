import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin CupertinoDialogMixin {
  Future<void> customLeftCupertinoDialog(
    BuildContext context, {
    required String content,
    required String leftButton,
    Function()? onTap,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(content, style: context.textTheme.titleSmall),
        actions: [
          CupertinoDialogAction(
            onPressed: onTap,
            child: Text(
              leftButton,
              style: context.textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          CupertinoDialogAction(
            child: Text('Cancel', style: context.textTheme.labelMedium!),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> customRightCupertinoDialog(
    BuildContext context, {
    required String content,
    required String rightButton,
    Function()? onTap,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(content, style: context.textTheme.titleSmall),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel', style: context.textTheme.labelLarge!),
            onPressed: () {
              context.pop();
            },
          ),
          CupertinoDialogAction(
            onPressed: onTap,
            child: Text(
              rightButton,
              style: context.textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
