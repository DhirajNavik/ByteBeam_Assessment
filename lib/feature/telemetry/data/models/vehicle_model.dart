import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'vehicle_model.freezed.dart';

@freezed
abstract class VehicleModel with _$VehicleModel {
  const VehicleModel._();

  const factory VehicleModel({
    required int id,
    required String registration,
    required String model,
  }) = _VehicleModel;

  factory VehicleModel.fromLocalJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json[VehicleTable.id],
      registration: json[VehicleTable.registrationNumber],
      model: json[VehicleTable.model],
    );
  }

  VehicleEntity toEntity() {
    return VehicleEntity(id: id, registration: registration, model: model);
  }
}
