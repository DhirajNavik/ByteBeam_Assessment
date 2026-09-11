import 'package:bytebeam_assessment/feature/alerts/data/models/alert_model.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';

abstract interface class AlertsDataSource {
  Stream<List<AlertModel>> watchActiveAlerts();

  Future<void> dismiss({required int alertId, required DismissReason reason});

  Future<void> undoDismiss(int alertId);

  /// Starts the periodic reconciliation tick (latest telemetry ->
  /// [AlertReconciler] -> persisted mutations). Idempotent: calling this
  /// twice does not start a second timer.
  void startReconciliation();

  void stopReconciliation();
}
