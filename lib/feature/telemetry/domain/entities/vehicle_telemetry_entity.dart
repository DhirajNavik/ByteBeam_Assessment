import 'package:equatable/equatable.dart';

class VehicleTelemetryEntity extends Equatable {
  final int vehicleId;
  final double? soc;
  final double? speed;
  final double? batteryTemp;
  final double? range;
  final double? odometer;
  final DateTime? lastPingAt;
  final String status;

  const VehicleTelemetryEntity({
    required this.vehicleId,
    required this.soc,
    required this.speed,
    required this.batteryTemp,
    required this.range,
    required this.odometer,
    required this.lastPingAt,
    required this.status,
  });

  bool get isStale =>
      lastPingAt == null ||
      DateTime.now().difference(lastPingAt!).inMinutes > 10;

  bool get hasAlert => soc != null && soc! < 20;

  bool get isCritical => soc != null && soc! < 10;

  @override
  List<Object?> get props => [
    vehicleId,
    soc,
    speed,
    batteryTemp,
    range,
    odometer,
    lastPingAt,
    status,
  ];
}
