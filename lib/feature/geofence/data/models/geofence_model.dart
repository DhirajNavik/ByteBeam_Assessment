import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';

class GeofenceModel {
  const GeofenceModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory GeofenceModel.fromLocalJson(Map<String, dynamic> json) {
    return GeofenceModel(
      id: (json[GeofenceTable.id] as num).toInt(),
      name: json[GeofenceTable.name] as String,
      latitude: (json[GeofenceTable.latitude] as num).toDouble(),
      longitude: (json[GeofenceTable.longitude] as num).toDouble(),
      radiusMeters: (json[GeofenceTable.radiusMeters] as num).toDouble(),
      isActive: json[GeofenceTable.isActive] as bool,
      createdAt: json[GeofenceTable.createdAt] as DateTime,
      updatedAt: json[GeofenceTable.updatedAt] as DateTime,
    );
  }

  GeofenceEntity toEntity() => GeofenceEntity(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}