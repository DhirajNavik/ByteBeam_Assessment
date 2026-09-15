import 'package:bytebeam_assessment/core/database/utils/trip_reconciler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime(2026, 1, 1, 8, 0, 0);
  final t1 = DateTime(2026, 1, 1, 8, 30, 0);

  UnconsumedCrossing crossing({
    int eventId = 1,
    int vehicleId = 1,
    int geofenceId = 10,
    GeofenceCrossingType type = GeofenceCrossingType.exit,
    DateTime? eventTime,
    int sequenceId = 1,
  }) {
    return UnconsumedCrossing(
      eventId: eventId,
      vehicleId: vehicleId,
      geofenceId: geofenceId,
      type: type,
      eventTime: eventTime ?? t0,
      sequenceId: sequenceId,
    );
  }

  group('TripReconciler', () {
    test('returns empty mutations when there are no unconsumed crossings', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [],
        activeTrips: [],
      );

      expect(mutations, isEmpty);
    });

    test('exit event starts a new trip when vehicle has no active trip', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 101,
            vehicleId: 1,
            geofenceId: 5,
            type: GeofenceCrossingType.exit,
            eventTime: t0,
            sequenceId: 1,
          ),
        ],
        activeTrips: [],
      );

      expect(mutations, hasLength(1));
      final mutation = mutations.first as StartTrip;
      expect(mutation.vehicleId, 1);
      expect(mutation.originGeofenceId, 5);
      expect(mutation.originEventId, 101);
      expect(mutation.startedAt, t0);
    });

    test('ignores exit event if vehicle already has an active trip', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 102,
            vehicleId: 1,
            geofenceId: 6,
            type: GeofenceCrossingType.exit,
            eventTime: t1,
            sequenceId: 2,
          ),
        ],
        activeTrips: [
          const ActiveTripRef(vehicleId: 1, tripId: 42),
        ],
      );

      expect(mutations, isEmpty);
    });

    test('entry event completes an active trip', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 103,
            vehicleId: 1,
            geofenceId: 7,
            type: GeofenceCrossingType.entry,
            eventTime: t1,
            sequenceId: 2,
          ),
        ],
        activeTrips: [
          const ActiveTripRef(vehicleId: 1, tripId: 42),
        ],
      );

      expect(mutations, hasLength(1));
      final mutation = mutations.first as CompleteTrip;
      expect(mutation.vehicleId, 1);
      expect(mutation.destinationGeofenceId, 7);
      expect(mutation.destinationEventId, 103);
      expect(mutation.completedAt, t1);
    });

    test('ignores entry event if vehicle has no active trip (orphan entry)', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 104,
            vehicleId: 1,
            geofenceId: 7,
            type: GeofenceCrossingType.entry,
            eventTime: t1,
            sequenceId: 1,
          ),
        ],
        activeTrips: [],
      );

      expect(mutations, isEmpty);
    });

    test('processes complete trip lifecycle: exit then entry in one batch', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 1,
            vehicleId: 1,
            geofenceId: 10,
            type: GeofenceCrossingType.exit,
            eventTime: t0,
            sequenceId: 1,
          ),
          crossing(
            eventId: 2,
            vehicleId: 1,
            geofenceId: 20,
            type: GeofenceCrossingType.entry,
            eventTime: t1,
            sequenceId: 2,
          ),
        ],
        activeTrips: [],
      );

      expect(mutations, hasLength(2));
      expect(mutations[0], isA<StartTrip>());
      expect((mutations[0] as StartTrip).originGeofenceId, 10);
      expect(mutations[1], isA<CompleteTrip>());
      expect((mutations[1] as CompleteTrip).destinationGeofenceId, 20);
    });

    test('sorts out-of-order unconsumed crossings by sequenceId', () {
      // Entry comes before exit in list, but has higher sequenceId
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 2,
            vehicleId: 1,
            geofenceId: 20,
            type: GeofenceCrossingType.entry,
            eventTime: t1,
            sequenceId: 2,
          ),
          crossing(
            eventId: 1,
            vehicleId: 1,
            geofenceId: 10,
            type: GeofenceCrossingType.exit,
            eventTime: t0,
            sequenceId: 1,
          ),
        ],
        activeTrips: [],
      );

      expect(mutations, hasLength(2));
      expect(mutations[0], isA<StartTrip>());
      expect((mutations[0] as StartTrip).originEventId, 1);
      expect(mutations[1], isA<CompleteTrip>());
      expect((mutations[1] as CompleteTrip).destinationEventId, 2);
    });

    test('handles multiple vehicles independently', () {
      final mutations = TripReconciler.reconcile(
        unconsumedEvents: [
          crossing(
            eventId: 1,
            vehicleId: 1,
            geofenceId: 10,
            type: GeofenceCrossingType.exit,
            eventTime: t0,
            sequenceId: 1,
          ),
          crossing(
            eventId: 2,
            vehicleId: 2,
            geofenceId: 30,
            type: GeofenceCrossingType.entry,
            eventTime: t1,
            sequenceId: 1,
          ),
        ],
        activeTrips: [
          const ActiveTripRef(vehicleId: 2, tripId: 99),
        ],
      );

      expect(mutations, hasLength(2));
      final startTrip = mutations.whereType<StartTrip>().single;
      final completeTrip = mutations.whereType<CompleteTrip>().single;

      expect(startTrip.vehicleId, 1);
      expect(completeTrip.vehicleId, 2);
    });
  });
}
