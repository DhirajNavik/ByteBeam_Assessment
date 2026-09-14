
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_event_entity.dart';

final class VehiclePosition {
  const VehiclePosition({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.eventTime,
    required this.sequenceId,
  });

  final int vehicleId;
  final double latitude;
  final double longitude;
  final DateTime eventTime;
  final int sequenceId;
}

final class LastGeofenceState {
  const LastGeofenceState({
    required this.vehicleId,
    required this.geofenceId,
    required this.lastEventType,
    required this.lastSequenceId,
  });

  final int vehicleId;
  final int geofenceId;
  final GeofenceEventType lastEventType;
  final int lastSequenceId;
}

sealed class GeofenceMutation {
  const GeofenceMutation({
    required this.vehicleId,
    required this.geofenceId,
  });

  final int vehicleId;
  final int geofenceId;
}

final class RecordEntry extends GeofenceMutation {
  const RecordEntry({
    required super.vehicleId,
    required super.geofenceId,
    required this.latitude,
    required this.longitude,
    required this.eventTime,
    required this.sequenceId,
  });

  final double latitude;
  final double longitude;
  final DateTime eventTime;
  final int sequenceId;
}

final class RecordExit extends GeofenceMutation {
  const RecordExit({
    required super.vehicleId,
    required super.geofenceId,
    required this.latitude,
    required this.longitude,
    required this.eventTime,
    required this.sequenceId,
  });

  final double latitude;
  final double longitude;
  final DateTime eventTime;
  final int sequenceId;
}

abstract final class GeofenceReconciler {
  GeofenceReconciler._();

  static List<GeofenceMutation> reconcile({
    required List<VehiclePosition> positions,
    required List<GeofenceEntity> activeGeofences,
    required List<LastGeofenceState> lastStates,
    required double jitterThresholdMeters,
  }) {
    final mutations = <GeofenceMutation>[];

    for (final position in positions) {
      for (final geofence in activeGeofences) {
        final isInside = geofence.containsPoint(
          position.latitude,
          position.longitude,
        );

        final lastState = _findLastState(
          lastStates,
          position.vehicleId,
          geofence.id,
        );

        if (lastState != null &&
            lastState.lastSequenceId >= position.sequenceId) {
          continue;
        }

        if (lastState == null) {
          if (isInside) {
            mutations.add(
              RecordEntry(
                vehicleId: position.vehicleId,
                geofenceId: geofence.id,
                latitude: position.latitude,
                longitude: position.longitude,
                eventTime: position.eventTime,
                sequenceId: position.sequenceId,
              ),
            );
          }
          continue;
        }

        final wasInside = lastState.lastEventType == GeofenceEventType.entry;

        if (wasInside && !isInside) {
          final distanceFromBoundary = geofence.distanceTo(
            position.latitude,
            position.longitude,
          );
          final distanceOutside = distanceFromBoundary - geofence.radiusMeters;

          if (distanceOutside < jitterThresholdMeters) {
            continue;
          }

          mutations.add(
            RecordExit(
              vehicleId: position.vehicleId,
              geofenceId: geofence.id,
              latitude: position.latitude,
              longitude: position.longitude,
              eventTime: position.eventTime,
              sequenceId: position.sequenceId,
            ),
          );
        } else if (!wasInside && isInside) {
          mutations.add(
            RecordEntry(
              vehicleId: position.vehicleId,
              geofenceId: geofence.id,
              latitude: position.latitude,
              longitude: position.longitude,
              eventTime: position.eventTime,
              sequenceId: position.sequenceId,
            ),
          );
        }
      }
    }

    return mutations;
  }

  static LastGeofenceState? _findLastState(
    List<LastGeofenceState> states,
    int vehicleId,
    int geofenceId,
  ) {
    for (final state in states) {
      if (state.vehicleId == vehicleId && state.geofenceId == geofenceId) {
        return state;
      }
    }
    return null;
  }
}