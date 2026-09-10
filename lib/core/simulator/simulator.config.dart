import 'dart:math';

import 'package:bytebeam_assessment/core/simulator/simulation.state.dart';

/// Derives every simulation parameter from the vehicle's current state.
/// No fixed values — each getter is a function of [state].
final class SimulationConfig {
  SimulationConfig(this.state);

  final SimulationState state;

  static final Random _random = Random();

  // ─────────────────────────────────────────────
  // Temperature thresholds
  // Derived from the vehicle's rated operating range stored in state.
  // ─────────────────────────────────────────────

  /// Ideal operating temperature — 60 % of the way through the safe band.
  double get normalTemperature =>
      state.minOperatingTemp +
      (state.maxOperatingTemp - state.minOperatingTemp) * 0.60;

  /// Temperature below which active cooling is not needed.
  double get coolTemperature =>
      state.minOperatingTemp +
      (state.maxOperatingTemp - state.minOperatingTemp) * 0.55;

  /// Temperature at which performance is throttled.
  double get warningTemperature =>
      state.minOperatingTemp +
      (state.maxOperatingTemp - state.minOperatingTemp) * 0.80;

  /// Temperature at which speed is heavily reduced.
  double get highTemperature =>
      state.minOperatingTemp +
      (state.maxOperatingTemp - state.minOperatingTemp) * 0.90;

  /// Temperature at which the vehicle shuts down.
  double get criticalTemperature => state.maxOperatingTemp;

  // ─────────────────────────────────────────────
  // Driving-cycle thresholds
  // ─────────────────────────────────────────────

  /// How many ticks a vehicle drives before it stops again.
  int get maxDrivingTicks =>
      (state.driveCycleLengthFactor * 20).round().clamp(10, 60);

  /// How many stopped ticks before the vehicle starts moving again.
  int get minStoppedTicksBeforeDriving =>
      (state.stopCycleLengthFactor * 8).round().clamp(3, 20);

  // ─────────────────────────────────────────────
  // Speed targets — all fractions of state.maxSpeed
  // ─────────────────────────────────────────────

  double get lowSpeedRecoveryMin    => state.maxSpeed * 0.40;
  double get lowSpeedRecoverySpread => state.maxSpeed * 0.20;
  double get lowSpeedThreshold      => state.maxSpeed * 0.35;

  double get warningTempSpeedMin    => state.maxSpeed * 0.35;
  double get warningTempSpeedSpread => state.maxSpeed * 0.08;

  double get highTempSpeedMin       => state.maxSpeed * 0.25;
  double get highTempSpeedSpread    => state.maxSpeed * 0.08;

  double get preCriticalSpeedMin    => state.maxSpeed * 0.10;
  double get preCriticalSpeedSpread => state.maxSpeed * 0.08;

  /// Random target speed used when a vehicle transitions from stopped → driving.
  double get startingTargetSpeed =>
      lowSpeedRecoveryMin + _random.nextDouble() * lowSpeedRecoverySpread;

  // ─────────────────────────────────────────────
  // Speed ramping
  // ─────────────────────────────────────────────

  /// km/h added per tick when accelerating.
  double get accelerationStep => state.maxSpeed * 0.04;

  /// km/h removed per tick when decelerating.
  double get decelerationStep => state.maxSpeed * 0.05;

  // ─────────────────────────────────────────────
  // SOC consumption
  // Scaled by batteryCapacityKwh — larger pack → slower % drain.
  // ─────────────────────────────────────────────

  double get _capacityScale => 30.0 / state.batteryCapacityKwh.clamp(10, 200);

  double get idleSocDrain           => 0.001 * _capacityScale;
  double get baseSocConsumption     => 0.008 * _capacityScale;
  double get speedSocFactor         => 0.015 * _capacityScale;
  double get accelerationSocPenalty => 0.012 * _capacityScale;
  double get warningTempSocPenalty  => 0.008 * _capacityScale;
  double get highTempSocPenalty     => 0.012 * _capacityScale;

  // ─────────────────────────────────────────────
  // Temperature dynamics
  // ─────────────────────────────────────────────

  double get _tempBand => state.maxOperatingTemp - state.minOperatingTemp;

  double get idleCoolingRate           => _tempBand * 0.0100;
  double get idleWarmingRate           => _tempBand * 0.0030;
  double get temperatureSnapThreshold  => 0.05;
  double get baseHeatRate              => _tempBand * 0.0014;
  double get speedHeatFactor           => _tempBand * 0.0028;
  double get accelerationHeatPenalty   => _tempBand * 0.0033;
  double get highSpeedHeatThreshold    => state.maxSpeed * 0.75;
  double get highSpeedHeatPenalty      => _tempBand * 0.0028;

  // ─────────────────────────────────────────────
  // Range estimation (km / SOC %)
  // ─────────────────────────────────────────────

  double get baseKmPerSoc                      => state.totalRange / 100.0;
  double get highSpeedEfficiencyMultiplier     => 0.83;
  double get mediumHighSpeedEfficiencyMultiplier => 0.90;
  double get mediumSpeedEfficiencyMultiplier   => 0.97;
  double get warningTempRangePenalty           => baseKmPerSoc * 0.050;
  double get highTempRangePenalty              => baseKmPerSoc * 0.067;
  double get minKmPerSoc                       => baseKmPerSoc * 0.50;

  // ─────────────────────────────────────────────
  // Odometer
  // ─────────────────────────────────────────────

  int get tickIntervalSeconds => state.tickIntervalSeconds;

  // ─────────────────────────────────────────────
  // Location interpolation
  // ─────────────────────────────────────────────

  double get locationMovementFactor => (state.speed / state.maxSpeed) * 0.01;
  double get locationSnapThreshold  => 0.0005;
}