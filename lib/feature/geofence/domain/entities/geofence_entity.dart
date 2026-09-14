import 'dart:math';

import 'package:equatable/equatable.dart';

class GeofenceEntity extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GeofenceEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool containsPoint(double lat, double lon) {
    const earthRadiusM = 6371000.0;
    final dLat = _toRad(lat - latitude);
    final dLon = _toRad(lon - longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(latitude)) *
            cos(_toRad(lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusM * c <= radiusMeters;
  }

  double distanceTo(double lat, double lon) {
    const earthRadiusM = 6371000.0;
    final dLat = _toRad(lat - latitude);
    final dLon = _toRad(lon - longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(latitude)) *
            cos(_toRad(lat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusM * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  @override
  List<Object?> get props =>
      [id, name, latitude, longitude, radiusMeters, isActive, createdAt, updatedAt];
}