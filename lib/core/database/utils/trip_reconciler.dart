enum GeofenceCrossingType {
  exit('exit'),
  entry('entry');

  const GeofenceCrossingType(this.value);
  final String value;

  static GeofenceCrossingType fromValue(String value) =>
      GeofenceCrossingType.values.firstWhere((t) => t.value == value);
}

final class UnconsumedCrossing {
  const UnconsumedCrossing({
    required this.eventId,
    required this.vehicleId,
    required this.geofenceId,
    required this.type,
    required this.eventTime,
    required this.sequenceId,
  });

  final int eventId;
  final int vehicleId;
  final int geofenceId;
  final GeofenceCrossingType type;
  final DateTime eventTime;
  final int sequenceId;
}

final class ActiveTripRef {
  const ActiveTripRef({required this.vehicleId, required this.tripId});
  final int vehicleId;
  final int tripId;
}

sealed class TripMutation {
  const TripMutation({required this.vehicleId});
  final int vehicleId;
}

final class StartTrip extends TripMutation {
  const StartTrip({
    required super.vehicleId,
    required this.originGeofenceId,
    required this.originEventId,
    required this.startedAt,
  });

  final int originGeofenceId;
  final int originEventId;
  final DateTime startedAt;
}

final class CompleteTrip extends TripMutation {
  const CompleteTrip({
    required super.vehicleId,
    required this.destinationGeofenceId,
    required this.destinationEventId,
    required this.completedAt,
  });

  final int destinationGeofenceId;
  final int destinationEventId;
  final DateTime completedAt;
}

abstract final class TripReconciler {
  TripReconciler._();

  static List<TripMutation> reconcile({
    required List<UnconsumedCrossing> unconsumedEvents,
    required List<ActiveTripRef> activeTrips,
  }) {
    final mutations = <TripMutation>[];

    final isOpen = <int, bool>{
      for (final t in activeTrips) t.vehicleId: true,
    };

    final byVehicle = <int, List<UnconsumedCrossing>>{};
    for (final event in unconsumedEvents) {
      byVehicle.putIfAbsent(event.vehicleId, () => []).add(event);
    }

    for (final entry in byVehicle.entries) {
      final vehicleId = entry.key;
      final events = entry.value
        ..sort((a, b) => a.sequenceId.compareTo(b.sequenceId));

      for (final event in events) {
        final open = isOpen[vehicleId] ?? false;

        switch (event.type) {
          case GeofenceCrossingType.exit:
            if (open) continue; // one active trip per vehicle; ignore.
            mutations.add(
              StartTrip(
                vehicleId: vehicleId,
                originGeofenceId: event.geofenceId,
                originEventId: event.eventId,
                startedAt: event.eventTime,
              ),
            );
            isOpen[vehicleId] = true;

          case GeofenceCrossingType.entry:
            if (!open) continue; // nothing to complete; ignore.
            mutations.add(
              CompleteTrip(
                vehicleId: vehicleId,
                destinationGeofenceId: event.geofenceId,
                destinationEventId: event.eventId,
                completedAt: event.eventTime,
              ),
            );
            isOpen[vehicleId] = false;
        }
      }
    }

    return mutations;
  }
}