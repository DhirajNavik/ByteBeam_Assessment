import 'package:bytebeam_assessment/core/database/queries/vehicle.queries.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/core/extension/duck_db_parser_extension.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/datasource/telemetry_datasource.dart';
import 'package:bytebeam_assessment/feature/telemetry/data/models/vehicle_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TelemetryDataSource)
class TelemetryLocalDataSourceImpl implements TelemetryDataSource {
  final DatabaseRequester _database;

  const TelemetryLocalDataSourceImpl(this._database);
  @override
  Future<List<VehicleModel>> fetchVehicles() async {
    final response = await _database.query(VehicleQueries.fetchAll);
    return response.parseList(VehicleModel.fromLocalJson, [
      VehicleTable.id,
      VehicleTable.registrationNumber,
      VehicleTable.model,
    ]);
  }
}
