import 'dart:async';

import 'package:bytebeam_assessment/core/database/queries/trip.query.dart';
import 'package:bytebeam_assessment/core/database/utils/trip_reconciler.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/core/extension/duck_db_parser_extension.dart';
import 'package:bytebeam_assessment/feature/trips/data/datasources/trip_datasource.dart';
import 'package:bytebeam_assessment/feature/trips/data/models/trip_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TripsDataSource)
class TripsLocalDataSourceImpl implements TripsDataSource {
  final DatabaseRequester _database;

  TripsLocalDataSourceImpl(this._database);

  Timer? _reconcileTimer;

  @override
  void startReconciliation() {
    if (_reconcileTimer != null) return;
    // Trips are derived from geofence events, which are themselves produced
    // on a 5s tick — piggyback on the same cadence rather than polling
    // faster than the data that feeds it can possibly change.
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
      final eventRows = await _database.query(TripQuery.fetchUnconsumedEvents);
      if (eventRows.isEmpty) return;

      final unconsumed = eventRows
          .map(
            (row) => UnconsumedCrossing(
              eventId: (row[0] as num).toInt(),
              vehicleId: (row[1] as num).toInt(),
              geofenceId: (row[2] as num).toInt(),
              type: GeofenceCrossingType.fromValue(row[3] as String),
              eventTime: row[4] as DateTime,
              sequenceId: (row[5] as num).toInt(),
            ),
          )
          .toList();

      final activeRows = await _database.query(TripQuery.fetchActiveTrips);
      final activeTrips = activeRows
          .map(
            (row) => ActiveTripRef(
              tripId: (row[0] as num).toInt(),
              vehicleId: (row[1] as num).toInt(),
            ),
          )
          .toList();

      final mutations = TripReconciler.reconcile(
        unconsumedEvents: unconsumed,
        activeTrips: activeTrips,
      );

      if (mutations.isEmpty) return;

      // vehicleId -> open trip id. Seeded from DB, then updated locally as
      // StartTrip mutations are applied so a start+complete pair produced
      // within the same tick resolves correctly.
      final tripIdByVehicle = {
        for (final t in activeTrips) t.vehicleId: t.tripId,
      };

      final nextIdRow = await _database.query(TripQuery.nextId);
      var nextId = (nextIdRow.first.first as num).toInt() + 1;

      for (final mutation in mutations) {
        switch (mutation) {
          case StartTrip m:
            final tripId = nextId++;
            await _database.query(
              TripQuery.insert(
                id: tripId,
                vehicleId: m.vehicleId,
                originGeofenceId: m.originGeofenceId,
                originEventId: m.originEventId,
                startedAt: m.startedAt,
              ),
            );
            tripIdByVehicle[m.vehicleId] = tripId;

          case CompleteTrip m:
            final tripId = tripIdByVehicle[m.vehicleId];
            if (tripId == null) continue; // defensive; shouldn't happen.
            await _database.query(
              TripQuery.complete(
                tripId: tripId,
                destinationGeofenceId: m.destinationGeofenceId,
                destinationEventId: m.destinationEventId,
                completedAt: m.completedAt,
              ),
            );
            tripIdByVehicle.remove(m.vehicleId);
        }
      }
    } catch (e) {
      debugPrint('Trip reconciliation tick failed: $e');
    }
  }

  @override
  Stream<List<TripModel>> watchAll() async* {
    while (true) {
      final rows = await _database.query(TripQuery.fetchAll);
      yield rows.parseList(TripModel.fromLocalJson, TripQuery.fetchAllColumns);
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }
}