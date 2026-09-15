import 'package:bytebeam_assessment/core/components/common_slidable_container.dart';
import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/app_images.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/core/utils/sized_box.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:flutter/material.dart';

import 'alert_card.dart';

class AlertDismissible extends StatelessWidget {
  const AlertDismissible({
    super.key,
    required this.entity,
    required this.onDismissed,
  });
  final AlertEntity entity;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return CommonSlidableContainer(
      extendRatio: 0.27,
      actions: [
        SizeBox.sizeWX4,
        Expanded(
          child: ActionButton.getButtons(
            onTap: onDismissed,
            size: Size.infinite,
            color: context.colorScheme.error,
            svgIcon: AppImages.close,
            borderRadius: Dimens.radiusX3,
          ),
        ),
      ],
      child: AlertSeverityType.fromSeverity(
        entity.severity,
      ).buildCard(context, entity),
    );
  }
}
