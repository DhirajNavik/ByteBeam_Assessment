import 'package:bytebeam_assessment/core/network/exception.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/alerts/data/datasource/alerts_datasource.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/repositories/alerts_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AlertsRepository)
class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsDataSource _dataSource;

  AlertsRepositoryImpl(this._dataSource) {
    _dataSource.startReconciliation();
  }

  @override
  Stream<Either<Failure, List<AlertEntity>>> watchActiveAlerts() async* {
    try {
      await for (final alerts in _dataSource.watchActiveAlerts()) {
        yield Right(alerts.map((e) => e.toEntity()).toList());
      }
    } on DatabaseException catch (error) {
      yield Left(LocalFailue(error.toString()));
    } catch (error) {
      yield Left(LocalFailue(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> dismiss({
    required int alertId,
    required DismissReason reason,
  }) async {
    try {
      await _dataSource.dismiss(alertId: alertId, reason: reason);
      return const Right(unit);
    } on DatabaseException catch (error) {
      return Left(LocalFailue(error.toString()));
    } catch (error) {
      return Left(LocalFailue(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> undoDismiss(int alertId) async {
    try {
      await _dataSource.undoDismiss(alertId);
      return const Right(unit);
    } on DatabaseException catch (error) {
      return Left(LocalFailue(error.toString()));
    } catch (error) {
      return Left(LocalFailue(error.toString()));
    }
  }
}
