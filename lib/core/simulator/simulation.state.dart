import 'package:bytebeam_assessment/core/database/utils/fleet_geo_constants.dart';

final class SimulationState {
  SimulationState({
    required this.vehicleId,
    required this.maxSpeed,
    required this.totalRange,
    this.batteryCapacityKwh = 30.0,
    this.minOperatingTemp = 20.0,
    this.maxOperatingTemp = 50.0,
    this.tickIntervalSeconds = 2,
    this.startLatitude = FleetGeoConstants.centerLat,
    this.startLongitude = FleetGeoConstants.centerLon,
    this.destinationLatitude = FleetGeoConstants.centerLat,
    this.destinationLongitude = FleetGeoConstants.centerLon,
    this.driveCycleLengthFactor = 1.0,
    this.stopCycleLengthFactor = 1.0,
    required this.soc,
    this.speed = 0.0,
    this.batteryTemperature = 29.0,
    this.rangeKm = 0.0,
    this.odometer = 0.0,
    this.ignition = 1,
    this.latitude = FleetGeoConstants.centerLat,
    this.longitude = FleetGeoConstants.centerLon,
    required this.lastSeen,
    this.driving = false,
    this.targetSpeed = 0.0,
    this.drivingTicks = 0,
    this.stoppedTicks = 0,
    this.generated = false,
    this.charging = false,
  });

  final int vehicleId;
  final double maxSpeed;
  final double totalRange;
  final double batteryCapacityKwh;
  final double minOperatingTemp;
  final double maxOperatingTemp;
  final int tickIntervalSeconds;
  final double startLatitude;
  final double startLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final double driveCycleLengthFactor;
  final double stopCycleLengthFactor;

  double soc;
  double speed;
  double batteryTemperature;
  double rangeKm;
  double odometer;
  int ignition;
  double latitude;
  double longitude;
  DateTime lastSeen;

  bool driving;
  double targetSpeed;
  int drivingTicks;
  int stoppedTicks;
  bool generated;
  bool charging;

  SimulationState copyWith() => SimulationState(
        vehicleId: vehicleId,
        maxSpeed: maxSpeed,
        totalRange: totalRange,
        batteryCapacityKwh: batteryCapacityKwh,
        minOperatingTemp: minOperatingTemp,
        maxOperatingTemp: maxOperatingTemp,
        tickIntervalSeconds: tickIntervalSeconds,
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
        driveCycleLengthFactor: driveCycleLengthFactor,
        stopCycleLengthFactor: stopCycleLengthFactor,
        soc: soc,
        speed: speed,
        batteryTemperature: batteryTemperature,
        rangeKm: rangeKm,
        odometer: odometer,
        ignition: ignition,
        latitude: latitude,
        longitude: longitude,
        lastSeen: lastSeen,
        driving: driving,
        targetSpeed: targetSpeed,
        drivingTicks: drivingTicks,
        stoppedTicks: stoppedTicks,
        generated: generated,
        charging: charging,
      );

  @override
  String toString() =>
      'SimulationState('
      'vehicleId: $vehicleId, '
      'ignition: $ignition, '
      'soc: ${soc.toStringAsFixed(2)}, '
      'speed: ${speed.toStringAsFixed(1)}, '
      'temp: ${batteryTemperature.toStringAsFixed(1)}, '
      'range: ${rangeKm.toStringAsFixed(1)}, '
      'odometer: ${odometer.toStringAsFixed(2)}, '
      'lat: ${latitude.toStringAsFixed(5)}, '
      'lon: ${longitude.toStringAsFixed(5)}, '
      'driving: $driving, '
      'charging: $charging, '
      'generated: $generated'
      ')';
}