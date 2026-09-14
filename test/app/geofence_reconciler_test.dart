import 'package:bytebeam_assessment/core/database/utils/geofence_reconciler.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final geofence = GeofenceEntity(
    id: 1,
    name: 'Warehouse',
    latitude: 12.9716,
    longitude: 77.5946,
    radiusMeters: 500,
    isActive: true,
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  final insidePosition = VehiclePosition(
    vehicleId: 1,
    latitude: 12.9716,
    longitude: 77.5946,
    eventTime: DateTime(2024, 1, 1, 10),
    sequenceId: 1,
  );

  final outsidePosition = VehiclePosition(
    vehicleId: 1,
    latitude: 13.0800,
    longitude: 77.7000,
    eventTime: DateTime(2024, 1, 1, 11),
    sequenceId: 2,
  );

  const jitter = 30.0;

  group('GeofenceReconciler', () {
    test('records entry when vehicle first appears inside geofence', () {
      final mutations = GeofenceReconciler.reconcile(
        positions: [insidePosition],
        activeGeofences: [geofence],
        lastStates: [],
        jitterThresholdMeters: jitter,
      );

      expect(mutations.length, 1);
      expect(mutations.first, isA<RecordEntry>());
      final entry = mutations.first as RecordEntry;
      expect(entry.vehicleId, 1);
      expect(entry.geofenceId, 1);
      expect(entry.sequenceId, 1);
    });

    test('no mutation when vehicle first appears outside geofence', () {
      final mutations = GeofenceReconciler.reconcile(
        positions: [outsidePosition],
        activeGeofences: [geofence],
        lastStates: [],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('records exit when vehicle moves outside after entry', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 1,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [outsidePosition],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations.length, 1);
      expect(mutations.first, isA<RecordExit>());
      final exit = mutations.first as RecordExit;
      expect(exit.vehicleId, 1);
      expect(exit.geofenceId, 1);
      expect(exit.sequenceId, 2);
    });

    test('records entry when vehicle re-enters after exit', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.exit,
        lastSequenceId: 2,
      );

      final reEntryPosition = VehiclePosition(
        vehicleId: 1,
        latitude: 12.9716,
        longitude: 77.5946,
        eventTime: DateTime(2024, 1, 1, 12),
        sequenceId: 3,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [reEntryPosition],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations.length, 1);
      expect(mutations.first, isA<RecordEntry>());
    });

    test('ignores stale packet with lower sequence id', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 10,
      );

      final latePacket = VehiclePosition(
        vehicleId: 1,
        latitude: 13.0800,
        longitude: 77.7000,
        eventTime: DateTime(2024, 1, 1, 9),
        sequenceId: 5,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [latePacket],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('suppresses exit when vehicle is within jitter threshold', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 1,
      );

      final jitterPosition = VehiclePosition(
        vehicleId: 1,
        latitude: 12.9716,
        longitude: 77.5993,
        eventTime: DateTime(2024, 1, 1, 10, 30),
        sequenceId: 2,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [jitterPosition],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('no duplicate entry when vehicle stays inside', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 1,
      );

      final stillInside = VehiclePosition(
        vehicleId: 1,
        latitude: 12.9716,
        longitude: 77.5946,
        eventTime: DateTime(2024, 1, 1, 10, 30),
        sequenceId: 2,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [stillInside],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('no duplicate exit when vehicle stays outside', () {
      final lastState = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.exit,
        lastSequenceId: 2,
      );

      final stillOutside = VehiclePosition(
        vehicleId: 1,
        latitude: 13.0800,
        longitude: 77.7000,
        eventTime: DateTime(2024, 1, 1, 12),
        sequenceId: 3,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [stillOutside],
        activeGeofences: [geofence],
        lastStates: [lastState],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('handles multiple vehicles independently', () {
      final vehicle2Inside = VehiclePosition(
        vehicleId: 2,
        latitude: 12.9716,
        longitude: 77.5946,
        eventTime: DateTime(2024, 1, 1, 10),
        sequenceId: 1,
      );

      final lastStateVehicle1 = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 1,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [outsidePosition, vehicle2Inside],
        activeGeofences: [geofence],
        lastStates: [lastStateVehicle1],
        jitterThresholdMeters: jitter,
      );

      expect(mutations.length, 2);

      final vehicle1Mutation = mutations.firstWhere((m) => m.vehicleId == 1);
      final vehicle2Mutation = mutations.firstWhere((m) => m.vehicleId == 2);

      expect(vehicle1Mutation, isA<RecordExit>());
      expect(vehicle2Mutation, isA<RecordEntry>());
    });

    test('handles multiple geofences simultaneously', () {
      final geofence2 = GeofenceEntity(
        id: 2,
        name: 'Depot',
        latitude: 13.0800,
        longitude: 77.7000,
        radiusMeters: 500,
        isActive: true,
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      );

      final position = VehiclePosition(
        vehicleId: 1,
        latitude: 13.0800,
        longitude: 77.7000,
        eventTime: DateTime(2024, 1, 1, 12),
        sequenceId: 3,
      );

      final lastStateG1 = LastGeofenceState(
        vehicleId: 1,
        geofenceId: 1,
        lastEventType: GeofenceEventType.entry,
        lastSequenceId: 1,
      );

      final mutations = GeofenceReconciler.reconcile(
        positions: [position],
        activeGeofences: [geofence, geofence2],
        lastStates: [lastStateG1],
        jitterThresholdMeters: jitter,
      );

      expect(mutations.length, 2);

      final g1 = mutations.firstWhere((m) => m.geofenceId == 1);
      final g2 = mutations.firstWhere((m) => m.geofenceId == 2);

      expect(g1, isA<RecordExit>());
      expect(g2, isA<RecordEntry>());
    });

    test('empty geofences produces no mutations', () {
      final mutations = GeofenceReconciler.reconcile(
        positions: [insidePosition],
        activeGeofences: [],
        lastStates: [],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });

    test('empty positions produces no mutations', () {
      final mutations = GeofenceReconciler.reconcile(
        positions: [],
        activeGeofences: [geofence],
        lastStates: [],
        jitterThresholdMeters: jitter,
      );

      expect(mutations, isEmpty);
    });
  });

  group('GeofenceEntity.containsPoint', () {
    test('returns true for center point', () {
      expect(geofence.containsPoint(12.9716, 77.5946), isTrue);
    });

    test('returns true for point within radius', () {
      expect(geofence.containsPoint(12.9740, 77.5950), isTrue);
    });

    test('returns false for point well outside radius', () {
      expect(geofence.containsPoint(13.0800, 77.7000), isFalse);
    });
  });
}