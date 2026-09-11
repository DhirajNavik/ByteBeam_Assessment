import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/repositories/alerts_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class WatchActiveAlertsUsecase
    extends UseCase<List<AlertEntity>, NoParams> {
  final AlertsRepository _repository;

  WatchActiveAlertsUsecase(this._repository);

  @override
  Stream<Either<Failure, List<AlertEntity>>> watch(NoParams params) {
    return _repository.watchActiveAlerts();
  }
}
