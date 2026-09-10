import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/repositories/telemetry_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class WatchFleetStatusUsecase
    extends UseCase<Map<int, String>, NoParams> {
  final TelemetryRepository _repository;

  WatchFleetStatusUsecase(this._repository);

  @override
  Stream<Either<Failure, Map<int, String>>> watch(NoParams params) {
    return _repository.watchFleetStatus();
  }
}
