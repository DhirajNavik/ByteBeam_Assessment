import 'package:equatable/equatable.dart';

class VehicleGeofenceEntity extends Equatable {
  final int vehicleId;
  final int geofenceId;
  final String geofenceName;

  const VehicleGeofenceEntity({
    required this.vehicleId,
    required this.geofenceId,
    required this.geofenceName,
  });

  @override
  List<Object?> get props => [vehicleId, geofenceId, geofenceName];
}