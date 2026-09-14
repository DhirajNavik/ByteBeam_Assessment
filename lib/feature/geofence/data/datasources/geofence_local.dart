import 'dart:async';

import 'package:bytebeam_assessment/core/database/queries/geofence.query.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence_event.table.dart';
import 'package:bytebeam_assessment/core/database/tables/vehicle.table.dart';
import 'package:bytebeam_assessment/core/database/utils/geofence_reconciler.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/feature/geofence/data/datasources/geofence_datasource.dart';
import 'package:bytebeam_assessment/feature/geofence/data/models/geofemce_event_model.dart';
import 'package:bytebeam_assessment/feature/geofence/data/models/geofence_model.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GeofenceDataSource)
class GeofenceLocalDataSourceImpl implements GeofenceDataSource {
  final DatabaseRequester _database;

  GeofenceLocalDataSourceImpl(this._database);

  Timer? _reconcileTimer;

  static const double _jitterThresholdMeters = 30.0;

  @override
  void startReconciliation() {
    if (_reconcileTimer != null) return;
    _reconcileTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _tick(),
    );
    unawaited(_tick());
  }

  @override
  void stopReconciliation() {
    _reconcileTimer?.cancel();
    _reconcileTimer = null;
  }

  Future<void> _tick() async {
    try {
      final geofenceRows = await _database.query(GeofenceQuery.fetchActive);
      if (geofenceRows.isEmpty) return;

      final geofences = geofenceRows
          .map(
            (row) => GeofenceModel.fromLocalJson({
              GeofenceTable.id: row[0],
              GeofenceTable.name: row[1],
              GeofenceTable.latitude: row[2],
              GeofenceTable.longitude: row[3],
              GeofenceTable.radiusMeters: row[4],
              GeofenceTable.isActive: row[5],
              GeofenceTable.createdAt: row[6],
              GeofenceTable.updatedAt: row[7],
            }).toEntity(),
          )
          .toList();

      final positionRows = await _database.query(
        GeofenceQuery.fetchLatestPositionsForReconciliation,
      );
      if (positionRows.isEmpty) return;

      final positions = positionRows
          .map(
            (row) => VehiclePosition(
              vehicleId: (row[0] as num).toInt(),
              latitude: (row[1] as num).toDouble(),
              longitude: (row[2] as num).toDouble(),
              eventTime: row[3] as DateTime,
              sequenceId: (row[4] as num).toInt(),
            ),
          )
          .toList();

      final lastStates = <LastGeofenceState>[];

      for (final geofence in geofences) {
        for (final position in positions) {
          final lastRows = await _database.query(
            GeofenceQuery.fetchLastEventForVehicleGeofence(
              vehicleId: position.vehicleId,
              geofenceId: geofence.id,
            ),
          );
          if (lastRows.isEmpty) continue;

          final row = lastRows.first;
          lastStates.add(
            LastGeofenceState(
              vehicleId: (row[2] as num).toInt(),
              geofenceId: (row[1] as num).toInt(),
              lastEventType: GeofenceEventType.fromValue(row[3] as String),
              lastSequenceId: (row[5] as num).toInt(),
            ),
          );
        }
      }

      final mutations = GeofenceReconciler.reconcile(
        positions: positions,
        activeGeofences: geofences,
        lastStates: lastStates,
        jitterThresholdMeters: _jitterThresholdMeters,
      );

      if (mutations.isEmpty) return;

      final nextIdRow = await _database.query(GeofenceQuery.nextEventId);
      var nextId = (nextIdRow.first.first as num).toInt() + 1;

      for (final mutation in mutations) {
        switch (mutation) {
          case RecordEntry m:
            await _database.query(
              GeofenceQuery.insertEvent(
                id: nextId++,
                geofenceId: m.geofenceId,
                vehicleId: m.vehicleId,
                eventType: GeofenceEventType.entry.value,
                eventTime: m.eventTime,
                sequenceId: m.sequenceId,
                latitude: m.latitude,
                longitude: m.longitude,
                createdAt: DateTime.now(),
              ),
            );
          case RecordExit m:
            await _database.query(
              GeofenceQuery.insertEvent(
                id: nextId++,
                geofenceId: m.geofenceId,
                vehicleId: m.vehicleId,
                eventType: GeofenceEventType.exit.value,
                eventTime: m.eventTime,
                sequenceId: m.sequenceId,
                latitude: m.latitude,
                longitude: m.longitude,
                createdAt: DateTime.now(),
              ),
            );
        }
      }
    } catch (e) {
      debugPrint('Geofence reconciliation tick failed: $e');
    }
  }

  @override
  Stream<List<GeofenceModel>> watchAll() async* {
    while (true) {
      final rows = await _database.query(GeofenceQuery.fetchAll);
      yield rows
          .map(
            (row) => GeofenceModel.fromLocalJson({
              GeofenceTable.id: row[0],
              GeofenceTable.name: row[1],
              GeofenceTable.latitude: row[2],
              GeofenceTable.longitude: row[3],
              GeofenceTable.radiusMeters: row[4],
              GeofenceTable.isActive: row[5],
              GeofenceTable.createdAt: row[6],
              GeofenceTable.updatedAt: row[7],
            }),
          )
          .toList();
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Future<void> create({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    final nextIdRow = await _database.query(GeofenceQuery.nextId);
    final nextId = (nextIdRow.first.first as num).toInt() + 1;

    await _database.query(
      GeofenceQuery.insert(
        id: nextId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> update({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    await _database.query(
      GeofenceQuery.update(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> setActive({required int id, required bool isActive}) async {
    await _database.query(
      GeofenceQuery.setActive(id: id, isActive: isActive, updatedAt: DateTime.now()),
    );
  }

  @override
  Stream<Map<int, int>> watchVehicleCounts() async* {
    while (true) {
      final rows = await _database.query(GeofenceQuery.vehicleCounts);
      yield {
        for (final row in rows)
          (row[0] as num).toInt(): (row[1] as num).toInt(),
      };
      await Future<void>.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Stream<List<VehicleGeofenceEntity>> watchVehicleGeofences() async* {
    while (true) {
      final rows = await _database.query(GeofenceQuery.vehicleCurrentGeofences);
      yield rows
          .map(
            (row) => VehicleGeofenceEntity(
              vehicleId: (row[0] as num).toInt(),
              geofenceId: (row[1] as num).toInt(),
              geofenceName: row[2] as String,
            ),
          )
          .toList();
      await Future<void>.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Future<List<GeofenceEventModel>> fetchEventsForVehicle(int vehicleId) async {
    final rows = await _database.query(
      GeofenceQuery.fetchEventsForVehicle(vehicleId),
    );
    return rows
        .map(
          (row) => GeofenceEventModel.fromLocalJson({
            GeofenceEventTable.id: row[0],
            GeofenceEventTable.geofenceId: row[1],
            VehicleTable.id: row[2],
            GeofenceEventTable.eventType: row[3],
            GeofenceEventTable.eventTime: row[4],
            GeofenceEventTable.sequenceId: row[5],
            GeofenceEventTable.latitude: row[6],
            GeofenceEventTable.longitude: row[7],
          }),
        )
        .toList();
  }
}