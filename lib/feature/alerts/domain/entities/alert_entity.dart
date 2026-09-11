import 'package:bytebeam_assessment/core/alerts/alert_thresholds.dart';
import 'package:equatable/equatable.dart';

class AlertEntity extends Equatable {
  final int id;
  final int vehicleId;
  final AlertType type;
  final AlertSeverity severity;
  final AlertStatus status;
  final DateTime triggeredAt;
  final DateTime updatedAt;
  final DateTime? dismissedAt;
  final String? dismissReason;
  final DateTime? resolvedAt;

  const AlertEntity({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.severity,
    required this.status,
    required this.triggeredAt,
    required this.updatedAt,
    this.dismissedAt,
    this.dismissReason,
    this.resolvedAt,
  });

  String get title => switch (type) {
    AlertType.batterySoc =>
      severity == AlertSeverity.critical
          ? 'Battery critically low'
          : 'Low battery',
    AlertType.batteryOverheat => 'Battery over heating',
  };

  bool get isCritical => severity == AlertSeverity.critical;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    type,
    severity,
    status,
    triggeredAt,
    updatedAt,
    dismissedAt,
    dismissReason,
    resolvedAt,
  ];
}

/// The three dismiss reasons, in the fixed order the spec requires the
/// reason sheet to present them.
enum DismissReason {
  onIt('I am on it'),
  wrongAlert('Wrong alert'),
  somethingElse('Something else…');

  const DismissReason(this.label);
  final String label;
}
