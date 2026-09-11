import 'dart:math';

import 'package:bytebeam_assessment/core/simulator/simulation.state.dart';

import 'simulator.config.dart';

/// Immutable snapshot of one vehicle's telemetry for a single tick.
///
/// [TelemetrySeeder] receives a list of these and blindly appends each
/// generated row to the DB — no simulation logic lives in the seeder.
final class TelemetrySnapshot {
  const TelemetrySnapshot({
    required this.vehicleId,
    required this.soc,
    required this.speed,
    required this.batteryTemperature,
    required this.rangeKm,
    required this.odometer,
    required this.ignition,
    required this.latitude,
    required this.longitude,
    required this.lastSeen,
    required this.generated,
    required this.driving, // NEW
    required this.targetSpeed, // NEW
    required this.drivingTicks, // NEW
    required this.stoppedTicks, // NEW
    required this.charging, // NEW
  });

  final int vehicleId;
  final double soc;
  final double speed;
  final double batteryTemperature;
  final double rangeKm;
  final double odometer;
  final int ignition;
  final double latitude;
  final double longitude;
  final DateTime lastSeen;
  final bool driving;
  final double targetSpeed;
  final int drivingTicks;
  final int stoppedTicks;
  final bool charging;

  /// Whether this tick produced a recordable change.
  /// The seeder skips rows where [generated] is false.
  final bool generated;

  // ─────────────────────────────────────────────────────────────────────────
  // Primary factory
  // ─────────────────────────────────────────────────────────────────────────

  /// Advances [last] by one simulation tick and returns an immutable snapshot.
  ///
  /// Internally mutates a throw-away copy of [last] so the caller's state
  /// is not changed until [tickAll] decides to commit.
  factory TelemetrySnapshot.fromLastState(
    SimulationState last, {
    double generateProbability = 0.8,
    Random? random,
  }) {
    final rng = random ?? Random();
    final next = last.copyWith();
    next.generated = false;

    final cfg = SimulationConfig(next);

    if (next.charging) {
      if (next.soc >= cfg.chargeStopSoc) next.charging = false;
    } else if (next.soc <= cfg.chargeStartSoc) {
      next.charging = true;
    }

    if (next.charging) {
      next
        ..ignition = 1
        ..driving = false
        ..targetSpeed = 0
        ..speed = 0;
      _updateCharging(next, cfg);
      _updateTemperature(next, cfg); // idle cooling toward normal
      next.lastSeen = DateTime.now();
      next.generated = true;
      return TelemetrySnapshot._fromState(next);
    }
    // ── Hard stops ────────────────────────────────────────────────────────
    if (next.ignition == 0 ||
        next.soc <= 0 ||
        next.batteryTemperature >= cfg.criticalTemperature) {
      next
        ..ignition = 0
        ..driving = false
        ..targetSpeed = 0
        ..speed = 0;
      return TelemetrySnapshot._fromState(next); // generated == false → skip
    }

    // ── Signal-drop simulation ────────────────────────────────────────────
    if (rng.nextDouble() >= generateProbability) {
      return TelemetrySnapshot._fromState(next); // generated == false → skip
    }

    // ── Simulation steps ──────────────────────────────────────────────────
    _updateDrivingState(next, cfg, rng);
    _updateTargetSpeed(next, cfg, rng);
    _updateSpeed(next, cfg);
    _updateSoc(next, cfg);
    _updateTemperature(next, cfg);
    _updateRange(next, cfg);
    _updateOdometer(next, cfg);
    _updateLocation(next, cfg);
    next.lastSeen = DateTime.now();

    // ── Post-update shutdown check ────────────────────────────────────────
    if (next.soc <= 0 || next.batteryTemperature >= cfg.criticalTemperature) {
      next
        ..ignition = 0
        ..driving = false
        ..targetSpeed = 0
        ..speed = 0;
      // Still emit this final record before shutting down
    }

    next.generated = true;
    return TelemetrySnapshot._fromState(next);
  }

  factory TelemetrySnapshot._fromState(SimulationState s) => TelemetrySnapshot(
    vehicleId: s.vehicleId,
    soc: s.soc,
    speed: s.speed,
    batteryTemperature: s.batteryTemperature,
    rangeKm: s.rangeKm,
    odometer: s.odometer,
    ignition: s.ignition,
    latitude: s.latitude,
    longitude: s.longitude,
    lastSeen: s.lastSeen,
    generated: s.generated,
    driving: s.driving, // NEW
    targetSpeed: s.targetSpeed, // NEW
    drivingTicks: s.drivingTicks, // NEW
    stoppedTicks: s.stoppedTicks,
    charging: s.charging,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Batch helper — used by TelemetrySeeder
  // ─────────────────────────────────────────────────────────────────────────

  /// Runs one tick for every vehicle in [states].
  ///
  /// Commits each generated snapshot back into the live state so subsequent
  /// calls start from the correct position. Returns all snapshots (both
  /// generated and skipped) so callers can filter on [generated].
  static List<TelemetrySnapshot> tickAll(
    Iterable<SimulationState> states, {
    double generateProbability = 0.8,
    Random? random,
  }) {
    final rng = random ?? Random();
    final snapshots = <TelemetrySnapshot>[];

    for (final state in states) {
      final snap = TelemetrySnapshot.fromLastState(
        state,
        generateProbability: generateProbability,
        random: rng,
      );
      state
        ..driving = snap.driving
        ..targetSpeed = snap.targetSpeed
        ..drivingTicks = snap.drivingTicks
        ..stoppedTicks = snap.stoppedTicks
        ..charging = snap.charging;
      // Commit generated tick back into the live state.
      if (snap.generated) {
        state
          ..soc = snap.soc
          ..speed = snap.speed
          ..batteryTemperature = snap.batteryTemperature
          ..rangeKm = snap.rangeKm
          ..odometer = snap.odometer
          ..ignition = snap.ignition
          ..latitude = snap.latitude
          ..longitude = snap.longitude
          ..lastSeen = snap.lastSeen;
      }

      snapshots.add(snap);
    }

    return snapshots;
  }

  static void _updateCharging(SimulationState s, SimulationConfig cfg) {
    s.soc = (s.soc + cfg.chargeRatePerTick).clamp(0, 100);
    // Range tracks the pack. The driving branch is skipped while
    // charging, so recompute here rather than leaving it stale.
    s.rangeKm = (s.soc * cfg.baseKmPerSoc).clamp(0, s.totalRange);
  }
  // ─────────────────────────────────────────────────────────────────────────
  // Simulation steps — pure functions of (SimulationState, SimulationConfig)
  // ─────────────────────────────────────────────────────────────────────────

  static void _updateDrivingState(
    SimulationState s,
    SimulationConfig cfg,
    Random rng,
  ) {
    if (s.ignition == 0 || s.batteryTemperature >= cfg.criticalTemperature) {
      s
        ..driving = false
        ..targetSpeed = 0
        ..stoppedTicks = s.stoppedTicks + 1;
      return;
    }

    if (s.driving) {
      s.drivingTicks++;
      if (s.drivingTicks >= cfg.maxDrivingTicks) {
        s
          ..driving = false
          ..targetSpeed = 0
          ..stoppedTicks = 0;
      }
    } else {
      s.stoppedTicks++;
      if (s.stoppedTicks >= cfg.minStoppedTicksBeforeDriving &&
          s.batteryTemperature <= cfg.warningTemperature) {
        s
          ..driving = true
          ..drivingTicks = 0
          ..stoppedTicks = 0
          ..targetSpeed = cfg.startingTargetSpeed.clamp(0, s.maxSpeed);
      }
    }
  }

  static void _updateTargetSpeed(
    SimulationState s,
    SimulationConfig cfg,
    Random rng,
  ) {
    if (!s.driving || s.ignition == 0) {
      s.targetSpeed = 0;
      return;
    }

    final temp = s.batteryTemperature;
    double newTarget;

    if (temp < cfg.warningTemperature) {
      newTarget = s.targetSpeed < cfg.lowSpeedThreshold
          ? cfg.lowSpeedRecoveryMin +
                rng.nextDouble() * cfg.lowSpeedRecoverySpread
          : s.targetSpeed;
    } else if (temp < cfg.highTemperature) {
      newTarget =
          cfg.warningTempSpeedMin +
          rng.nextDouble() * cfg.warningTempSpeedSpread;
    } else if (temp < cfg.criticalTemperature) {
      final mid = (cfg.highTemperature + cfg.criticalTemperature) / 2;
      newTarget = temp < mid
          ? cfg.highTempSpeedMin + rng.nextDouble() * cfg.highTempSpeedSpread
          : cfg.preCriticalSpeedMin +
                rng.nextDouble() * cfg.preCriticalSpeedSpread;
    } else {
      newTarget = 0;
    }

    s.targetSpeed = newTarget.clamp(0, s.maxSpeed);
  }

  static void _updateSpeed(SimulationState s, SimulationConfig cfg) {
    if (s.ignition == 0) {
      s.speed = 0;
      return;
    }
    if (s.speed < s.targetSpeed) {
      s.speed = (s.speed + cfg.accelerationStep).clamp(0, s.targetSpeed);
    } else if (s.speed > s.targetSpeed) {
      s.speed = (s.speed - cfg.decelerationStep).clamp(
        s.targetSpeed,
        double.infinity,
      );
    }
    s.speed = s.speed.clamp(0, s.maxSpeed);
  }

  static void _updateSoc(SimulationState s, SimulationConfig cfg) {
    if (s.ignition == 0) return;

    if (s.speed <= 0.1) {
      if (s.batteryTemperature > cfg.coolTemperature) {
        s.soc -= cfg.idleSocDrain;
      }
      s.soc = s.soc.clamp(0, 100);
      return;
    }

    double drain =
        cfg.baseSocConsumption + (s.speed / s.maxSpeed) * cfg.speedSocFactor;
    if (s.speed < s.targetSpeed) drain += cfg.accelerationSocPenalty;
    if (s.batteryTemperature >= cfg.warningTemperature) {
      drain += cfg.warningTempSocPenalty;
    }
    if (s.batteryTemperature >= cfg.highTemperature) {
      drain += cfg.highTempSocPenalty;
    }

    s.soc = (s.soc - drain).clamp(0, 100);
  }

  static void _updateTemperature(SimulationState s, SimulationConfig cfg) {
    // Idle cooling/warming happens regardless of ignition — a parked
    // vehicle's pack still sheds heat, which is what lets an
    // over-temperature shutdown recover.
    if (s.speed <= 0.1) {
      if (s.batteryTemperature > cfg.normalTemperature) {
        s.batteryTemperature -= cfg.idleCoolingRate;
      } else if (s.batteryTemperature < cfg.normalTemperature) {
        s.batteryTemperature += cfg.idleWarmingRate;
      }
      if ((s.batteryTemperature - cfg.normalTemperature).abs() <
          cfg.temperatureSnapThreshold) {
        s.batteryTemperature = cfg.normalTemperature;
      }
      return;
    }

    if (s.ignition == 0) return;

    double heat =
        cfg.baseHeatRate + (s.speed / s.maxSpeed) * cfg.speedHeatFactor;
    if (s.speed < s.targetSpeed) heat += cfg.accelerationHeatPenalty;
    if (s.speed > cfg.highSpeedHeatThreshold) heat += cfg.highSpeedHeatPenalty;

    s.batteryTemperature = (s.batteryTemperature + heat).clamp(
      20.0,
      cfg.criticalTemperature,
    );
  }

  static void _updateRange(SimulationState s, SimulationConfig cfg) {
    if (s.ignition == 0 || s.speed <= 0.1) return;

    double kmPerSoc = cfg.baseKmPerSoc;
    final ratio = s.speed / s.maxSpeed;

    if (ratio > 0.75) {
      kmPerSoc *= cfg.highSpeedEfficiencyMultiplier;
    } else if (ratio > 0.55) {
      kmPerSoc *= cfg.mediumHighSpeedEfficiencyMultiplier;
    } else if (ratio > 0.30) {
      kmPerSoc *= cfg.mediumSpeedEfficiencyMultiplier;
    }

    if (s.batteryTemperature >= cfg.warningTemperature) {
      kmPerSoc -= cfg.warningTempRangePenalty;
    }
    if (s.batteryTemperature >= cfg.highTemperature) {
      kmPerSoc -= cfg.highTempRangePenalty;
    }

    s.rangeKm = (s.soc * max(cfg.minKmPerSoc, kmPerSoc)).clamp(0, s.totalRange);
  }

  static void _updateOdometer(SimulationState s, SimulationConfig cfg) {
    if (s.ignition == 0 || s.speed <= 0.1) return;
    s.odometer += s.speed * cfg.tickIntervalSeconds / 3600;
  }

  static void _updateLocation(SimulationState s, SimulationConfig cfg) {
    if (s.ignition == 0 || s.speed <= 0.1) return;

    final latDiff = s.destinationLatitude - s.startLatitude;
    final lonDiff = s.destinationLongitude - s.startLongitude;
    final factor = cfg.locationMovementFactor;

    s.latitude += latDiff * factor;
    s.longitude += lonDiff * factor;

    if ((s.latitude - s.destinationLatitude).abs() <
        cfg.locationSnapThreshold) {
      s.latitude = s.destinationLatitude;
    }
    if ((s.longitude - s.destinationLongitude).abs() <
        cfg.locationSnapThreshold) {
      s.longitude = s.destinationLongitude;
    }
  }
}
