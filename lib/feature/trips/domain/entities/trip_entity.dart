import 'package:equatable/equatable.dart';

enum TripStatus {
  inProgress('in_progress'),
  completed('completed');

  const TripStatus(this.value);
  final String value;

  static TripStatus fromValue(String value) =>
      TripStatus.values.firstWhere((s) => s.value == value);
}

class TripEntity extends Equatable {
  final int id;
  final int vehicleId;
  final int originGeofenceId;
  final String originGeofenceName;
  final int? destinationGeofenceId;
  final String? destinationGeofenceName;
  final DateTime startedAt;
  final DateTime? completedAt;
  final TripStatus status;

  const TripEntity({
    required this.id,
    required this.vehicleId,
    required this.originGeofenceId,
    required this.originGeofenceName,
    required this.destinationGeofenceId,
    required this.destinationGeofenceName,
    required this.startedAt,
    required this.completedAt,
    required this.status,
  });

  bool get isInProgress => status == TripStatus.inProgress;

  @override
  List<Object?> get props => [
    id, vehicleId, originGeofenceId, originGeofenceName,
    destinationGeofenceId, destinationGeofenceName,
    startedAt, completedAt, status,
  ];
}