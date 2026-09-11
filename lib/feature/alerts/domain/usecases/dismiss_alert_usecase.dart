import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/repositories/alerts_repository.dart';
import 'package:fpdart/fpdart.dart';

final class DismissAlertParams {
  const DismissAlertParams({required this.alertId, required this.reason});
  final int alertId;
  final DismissReason reason;
}

@lazySingleton
final class DismissAlertUsecase extends UseCase<Unit, DismissAlertParams> {
  final AlertsRepository _repository;

  DismissAlertUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DismissAlertParams params) {
    return _repository.dismiss(alertId: params.alertId, reason: params.reason);
  }
}
