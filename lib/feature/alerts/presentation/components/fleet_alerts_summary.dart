import 'package:bytebeam_assessment/core/alerts/alert_thresholds.dart';
import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/app_palettes.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/alert_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FleetAlertsSummary extends StatelessWidget {
  const FleetAlertsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertsBloc, AlertsState>(
      builder: (context, state) {
        final alerts = state.maybeWhen(
          loaded: (alerts, _) => alerts,
          orElse: () => const [],
        );

        if (alerts.isEmpty) {
          return const SizedBox.shrink();
        }

        final critical = alerts
            .where((alert) => alert.severity == AlertSeverity.critical)
            .length;

        final warning = alerts
            .where((alert) => alert.severity == AlertSeverity.warning)
            .length;

        final severity = AlertSeverityType.fromSeverity(
          critical > 0 ? AlertSeverity.critical : AlertSeverity.warning,
        );

        final foreground = severity.color(context);
        final background = severity.colorContainer(context);

        final summary = [
          if (critical > 0) '$critical critical',
          if (warning > 0) '$warning warning',
        ].join(' · ');

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.horizontalspacing,
            vertical: Dimens.verPaddingX2,
          ),
          decoration: BoxDecoration(color: background.withOpacityExt(0.2)),
          child: Row(
            spacing: Dimens.gapX2,
            children: [
              Icon(severity.icon, size: Dimens.scaleX3, color: foreground),
              Text(
                summary,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
