import 'dart:async';
import 'dart:math';

import 'package:bytebeam_assessment/core/database/db_path.dart';
import 'package:bytebeam_assessment/core/database/queries/telemetry.query.dart';
import 'package:bytebeam_assessment/core/database/queries/vehicle.query.dart';
import 'package:bytebeam_assessment/core/simulator/simulation.state.dart';
import 'package:bytebeam_assessment/core/simulator/telemetry.snapshot.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/material.dart';

abstract final class TelemetrySeeder {
  TelemetrySeeder._();

  static Timer? _timer;
  static final Map<int, SimulationState> _states = {};

  /// Start the seeder — runs a tick every 2 seconds.
  static Future<void> start(Connection connection) async {
    if (_timer != null) return;

    await _initializeStates(connection);

    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        await _appendTelemetry(connection);
      } catch (e) {
        debugPrint('Telemetry seeder error: $e');
      }
    });
  }

  /// Stop the seeder.
  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  // State bootstrap — runs once on [start]

  static Future<void> _initializeStates(Connection connection) async {
    final vehicleResult = await connection.query(VehicleQuery.fetchAllProfiles);
    final vehicleRows = vehicleResult.fetchAll();
    await vehicleResult.dispose();

    if (vehicleRows.isEmpty) return;

    final vehicleMap = {
      for (final row in vehicleRows)
        (row[0] as num).toInt(): (
          maxSpeed: (row[1] as num).toDouble(),
          totalRange: (row[2] as num).toDouble(),
        ),
    };

    final telemetryResult = await connection.query(
      TelemetryQuery.fetchLatestTelemetry(vehicleMap.keys.toList()),
    );
    final telemetryRows = telemetryResult.fetchAll();
    await telemetryResult.dispose();

    _states.clear();

    if (telemetryRows.isNotEmpty) {
      // Resume from last persisted values
      for (final row in telemetryRows) {
        final vehicleId = (row[0] as num).toInt();
        final details = vehicleMap[vehicleId]!;
        final speed = (row[3] as num).toDouble();

        final state = SimulationState(
          vehicleId: vehicleId,
          maxSpeed: details.maxSpeed,
          totalRange: details.totalRange,
          latitude: (row[8] as num).toDouble(),
          longitude: (row[9] as num).toDouble(),
          soc: (row[2] as num).toDouble(),
          speed: speed,
          batteryTemperature: (row[4] as num).toDouble(),
          rangeKm: (row[5] as num).toDouble(),
          odometer: (row[6] as num).toDouble(),
          ignition: (row[7] as num).toInt(),
          lastSeen: row[10] as DateTime,
        );

        state
          ..driving = speed > 0.1
          ..targetSpeed = speed > 0.1 ? speed.clamp(0, state.maxSpeed) : 0.0
          ..drivingTicks = 0
          ..stoppedTicks = 0;

        _states[vehicleId] = state;
      }
    } else {
      // No history — create fresh states with deliberately wide, per-vehicle
      // variation so the fleet doesn't look cloned on first launch.
      final rng = Random();

      final entries = vehicleMap.entries.toList();

      // Assign SOC by walking a shuffled "strata" list so we're guaranteed a
      // realistic spread: a few near-empty (charging), some low (alerting),
      // most mid, some high — instead of pure uniform which clumps.
      final socBuckets = <double>[];
      for (var i = 0; i < entries.length; i++) {
        final roll = i / entries.length;
        if (roll < 0.05) {
          // 5% near-empty — will start charging on tick 1
          socBuckets.add(1.0 + rng.nextDouble() * 10);
        } else if (roll < 0.20) {
          // 15% low — will trigger the battery warning alert
          socBuckets.add(11.0 + rng.nextDouble() * 15);
        } else if (roll < 0.60) {
          // 40% mid
          socBuckets.add(40.0 + rng.nextDouble() * 25);
        } else {
          // 40% high
          socBuckets.add(65.0 + rng.nextDouble() * 35);
        }
      }
      socBuckets.shuffle(rng);

      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final soc = socBuckets[i].clamp(0.0, 100.0);

        // Each vehicle gets its own jittered operating profile.
        final batteryTemp = 22.0 + rng.nextDouble() * 22; // 22–44 °C
        final odometer = rng.nextDouble() * 90000 + 5000; // 5k–95k km
        final ignition = rng.nextDouble() < 0.9 ? 1 : 0; // 10% parked

        final state = SimulationState(
          vehicleId: entry.key,
          maxSpeed: entry.value.maxSpeed,
          totalRange: entry.value.totalRange,
          batteryCapacityKwh: 25.0 + rng.nextDouble() * 40, // 25–65 kWh
          // Scatter start positions a few km around Bengaluru.
          startLatitude: 12.85 + rng.nextDouble() * 0.25,
          startLongitude: 77.45 + rng.nextDouble() * 0.35,
          destinationLatitude: 12.85 + rng.nextDouble() * 0.25,
          destinationLongitude: 77.45 + rng.nextDouble() * 0.35,
          soc: soc,
          batteryTemperature: batteryTemp,
          rangeKm: entry.value.totalRange * (soc / 100),
          odometer: odometer,
          ignition: ignition,
          lastSeen: DateTime.now(),
          // Randomise which phase of the drive cycle each vehicle is in,
          // so the fleet doesn't move in lockstep.
          driving: ignition == 1 && rng.nextDouble() < 0.5,
          drivingTicks: rng.nextInt(20),
          stoppedTicks: rng.nextInt(8),
        );

        // Vehicles that are near-empty start charging rather than trying
        // to drive.
        state.charging = state.soc <= 15;

        if (state.driving) {
          state.targetSpeed = state.maxSpeed * (0.3 + rng.nextDouble() * 0.5);
        }

        _states[entry.key] = state;
      }
    }
  }

  static Future<void> _appendTelemetry(Connection connection) async {
    final snapshots = TelemetrySnapshot.tickAll(
      _states.values,
      generateProbability: 0.8,
    );

    final toWrite = snapshots.where((s) => s.generated).toList();
    if (toWrite.isEmpty) return;

    final seqResult = await connection.query(TelemetryQuery.nextSequenceId);
    int nextSeq = (seqResult.fetchAll().first.first as num).toInt() + 1;
    await seqResult.dispose();

    final appender = await connection.append(DBPath.telemetryTable, null);
    try {
      for (final snap in toWrite) {
        appender
          ..append(nextSeq++)
          ..append(snap.vehicleId)
          ..append(snap.soc)
          ..append(snap.speed)
          ..append(snap.batteryTemperature)
          ..append(snap.rangeKm)
          ..append(snap.odometer)
          ..append(snap.ignition.toDouble())
          ..append(snap.latitude)
          ..append(snap.longitude)
          ..append(snap.lastSeen)
          ..endRow();
      }
      appender.flush();
    } finally {
      appender.dispose();
    }
  }
}
