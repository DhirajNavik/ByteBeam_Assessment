import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AlertsRepository {
  /// Active alerts across the fleet, kept live by running the reconciler
  /// on each tick against the latest telemetry. Severity-desc, oldest
  /// first, matching [AlertQuery.fetchActiveAlerts].
  Stream<Either<Failure, List<AlertEntity>>> watchActiveAlerts();

  Future<Either<Failure, Unit>> dismiss({
    required int alertId,
    required DismissReason reason,
  });

  /// Reverts a dismissal made within the 5s undo window.
  Future<Either<Failure, Unit>> undoDismiss(int alertId);
}
