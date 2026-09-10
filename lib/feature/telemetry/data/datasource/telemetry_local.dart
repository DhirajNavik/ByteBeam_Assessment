import 'package:bytebeam_assessment/core/database/queries/telemetry.query.dart';
import 'package:bytebeam_assessment/core/database/queries/vehicle.query.dart';
import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/core/extension/duck_db_parser_extension.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/datasource/telemetry_datasource.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/fleet_status_model.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_model.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_telemetry_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TelemetryDataSource)
class TelemetryLocalDataSourceImpl implements TelemetryDataSource {
  final DatabaseRequester _database;

  const TelemetryLocalDataSourceImpl(this._database);
  @override
  Future<List<VehicleModel>> fetchVehicles() async {
    final response = await _database.query(VehicleQuery.fetchAllVehicles);
    return response.parseList(VehicleModel.fromLocalJson, [
      VehicleTable.id,
      VehicleTable.registrationNumber,
      VehicleTable.model,
    ]);
  }

  @override
  Stream<List<VehicleTelemetryModel>> watchVehicleTelemetry(
    List<int> vehicleIds,
  ) async* {
    while (true) {
      final response = await _database.query(
        TelemetryQuery.fetchLatestTelemetry(vehicleIds),
      );
      yield response.parseList(VehicleTelemetryModel.fromLocalJson, [
        VehicleTable.id,
        TelemetryTable.sequenceId,
        TelemetryTable.soc,
        TelemetryTable.speed,
        TelemetryTable.batteryTemp,
        TelemetryTable.range,
        TelemetryTable.odometer,
        TelemetryTable.ignition,
        TelemetryTable.latitude,
        TelemetryTable.longitude,
        TelemetryTable.lastSeen,
      ]);

      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Stream<Map<int, String>> watchFleetStatus() async* {
    while (true) {
      final response = await _database.query(
        TelemetryQuery.fetchLatestStatusAll,
      );

      final rows = response.parseList(FleetStatusModel.fromLocalJson, [
        VehicleTable.id,
        TelemetryTable.speed,
        TelemetryTable.ignition,
        TelemetryTable.lastSeen,
      ]);

      yield {for (final r in rows) r.vehicleId: r.status};

      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }
}
