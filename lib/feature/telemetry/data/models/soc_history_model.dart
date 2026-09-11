import 'package:bytebeam_assessment/core/database/tables/telemetry.table.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/soc_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'soc_history_model.freezed.dart';

@freezed
abstract class SOCHistoryModel with _$SOCHistoryModel {
  const SOCHistoryModel._();

  const factory SOCHistoryModel({
    required int id,
    required double soc,
    required DateTime? time,
  }) = _SOCHistoryModell;

  factory SOCHistoryModel.fromLocalJson(Map<String, dynamic> json) {
    return SOCHistoryModel(
      id: json[TelemetryTable.sequenceId] as int,
      soc: json[TelemetryTable.soc] as double,
      time: json[TelemetryTable.lastSeen] as DateTime?,
    );
  }

  SOCHistoryEntity toEntity() {
    return SOCHistoryEntity(
      id: id,
      soc: soc,
      time: time,
   
    );
  }
}
