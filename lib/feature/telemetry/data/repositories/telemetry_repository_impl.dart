import 'package:bytebeam_assessment/core/network/exception.dart';
import 'package:bytebeam_assessment/core/usecase/failures.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/datasource/telemetry_datasource.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_telemetry_model.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/repositories/telemetry_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TelemetryRepository)
class TelemetryRepositoryImpl implements TelemetryRepository {
  final TelemetryDataSource _dataSource;

  const TelemetryRepositoryImpl(this._dataSource);
  @override
  Future<Either<Failure, List<VehicleEntity>>> fetchAllVehicles() async {
    try {
      final vehicles = await _dataSource.fetchVehicles();
      return Right(vehicles.map((e) => e.toEntity()).toList());
    } on DatabaseException catch (error) {
      return Left(LocalFailue(error.toString()));
    } catch (error) {
      return Left(LocalFailue(error.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<VehicleTelemetryEntity>>> watchVehicleTelemetry(
    List<int> ids,
  ) async* {
    try {
      await for (final telemetry in _dataSource.watchVehicleTelemetry(ids)) {
        yield Right(telemetry.map((e) => e.toEntity()).toList());
      }
    } on DatabaseException catch (error) {
      yield Left(LocalFailue(error.toString()));
    } catch (error) {
      yield Left(LocalFailue(error.toString()));
    }
  }
}
