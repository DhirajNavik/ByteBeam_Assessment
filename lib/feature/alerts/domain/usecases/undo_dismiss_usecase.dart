import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/repositories/alerts_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class UndoDismissUsecase extends UseCase<Unit, int> {
  final AlertsRepository _repository;

  UndoDismissUsecase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(int alertId) {
    return _repository.undoDismiss(alertId);
  }
}
