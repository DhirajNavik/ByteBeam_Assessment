import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/extension/date_time_formatter.dart';
import 'package:bytebeam_assessment/core/utils/app_palettes.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/alert_card.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/handle_dismissable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertTile extends StatelessWidget with HandleDismissable {
  const AlertTile({super.key, required this.alert});

  final AlertEntity alert;

  AlertSeverityType get _severity =>
      AlertSeverityType.fromSeverity(alert.severity);

  @override
  Widget build(BuildContext context) {
    final fg = _severity.color(context);
    final bg = _severity.colorContainer(context);

    return InkWell(
      onTap: () async {
        final reason = await showDismissReasonSheet(context);
        if (reason == null) return;
        if (context.mounted) {
          context.read<AlertsBloc>().add(
            AlertsEvent.dismiss(alertId: alert.id, reason: reason),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.horPaddingX3,
          vertical: Dimens.verPaddingX2,
        ),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(Dimens.radiusX3),
          border: Border.all(color: bg.withOpacityExt(0.5)),
        ),
        child: Row(
          spacing: Dimens.gapX3,
          children: [
            Container(
              padding: .all(Dimens.allPaddingX2),
              decoration: BoxDecoration(
                color: bg.withOpacityExt(0.25),
                borderRadius: BorderRadius.circular(Dimens.radiusX2),
              ),
              child: Icon(_severity.icon, size: Dimens.scaleX3, color: fg),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.gapX1,
                children: [
                  Text(
                    alert.title,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    'Vehicle #${alert.vehicleId}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              spacing: Dimens.gapX1,
              crossAxisAlignment: .end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: bg.withOpacityExt(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _severity.label,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  alert.triggeredAt.toRelativeTime(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
