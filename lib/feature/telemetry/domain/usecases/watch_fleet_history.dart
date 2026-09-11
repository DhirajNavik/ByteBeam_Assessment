import 'package:bytebeam_assessment/config/routes/route_exports.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/core/usecase/usecase.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/soc_history_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/repositories/telemetry_repository.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
final class WatchFleetHistory
    extends UseCase<List<SOCHistoryEntity>, int> {
  final TelemetryRepository _repository;

  WatchFleetHistory(this._repository);

  @override
  Stream<Either<Failure, List<SOCHistoryEntity>>> watch(int params) {
    return _repository.watchSocHistory(params);
  }
}
