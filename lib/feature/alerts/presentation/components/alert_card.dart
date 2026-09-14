// ── Abstract base (mirrors FileType) ────────────────────────────────────────

import 'package:bytebeam_assessment/core/database/utils/alert_thresholds.dart';
import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/extension/date_time_formatter.dart';
import 'package:bytebeam_assessment/core/utils/app_palettes.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:flutter/material.dart';

abstract class AlertSeverityType {
  const AlertSeverityType();

  factory AlertSeverityType.fromSeverity(AlertSeverity severity) {
    return switch (severity) {
      AlertSeverity.warning => const WarningAlertType(),
      AlertSeverity.critical => const CriticalAlertType(),
    };
  }

  String get label;
  IconData get icon;
  Color color(BuildContext context);
  Color colorContainer(BuildContext context);

  Widget buildCard(BuildContext context, AlertEntity alert);
}

mixin AlertCardType on AlertSeverityType {
  @override
  Widget buildCard(BuildContext context, AlertEntity alert) {
    final fg = color(context);
    final bg = colorContainer(context);

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.horPaddingX4,
        vertical: Dimens.verPaddingX3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radiusX5),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .end,
        children: [
          Row(
            crossAxisAlignment: .start,
            spacing: Dimens.gapX3,
            children: [
              _buildIcon(bg, fg),
              Expanded(child: _buildTexts(context, alert)),
              _buildBadge(context, fg, bg),
            ],
          ),
          Text(alert.triggeredAt.toRelativeTime(),
          style: context.textTheme.labelMedium?.copyWith(fontWeight: .w700),
          )
        ],
      ),
    );
  }

  Widget _buildIcon(Color bg, Color fg) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg.withOpacityExt(0.2),
        borderRadius: BorderRadius.circular(Dimens.radiusX2),
      ),
      child: Icon(icon, size: 18, color: fg),
    );
  }

  Widget _buildTexts(BuildContext context, AlertEntity alert) {
    return Column(
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
    );
  }

  Widget _buildBadge(BuildContext context, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withOpacityExt(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Concrete types (mirrors ImageFileType / PdfFileType) ─────────────────────

class WarningAlertType extends AlertSeverityType with AlertCardType {
  const WarningAlertType();

  @override
  String get label => 'Warning';

  @override
  IconData get icon => Icons.info_outline_rounded;

  @override
  Color color(BuildContext context) => context.colorScheme.tertiary;

  @override
  Color colorContainer(BuildContext context) =>
      context.colorScheme.tertiaryContainer;
}

class CriticalAlertType extends AlertSeverityType with AlertCardType {
  const CriticalAlertType();

  @override
  String get label => 'Critical';

  @override
  IconData get icon => Icons.warning_amber_rounded;

  @override
  Color color(BuildContext context) => context.colorScheme.error;

  @override
  Color colorContainer(BuildContext context) =>
      context.colorScheme.errorContainer;
}
