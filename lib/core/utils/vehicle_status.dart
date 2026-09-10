import 'package:flutter/material.dart';

enum FleetStatus {
  all(
    value: 'ALL',
    label: 'All',
    icon: Icons.directions_car,
    backgroundColor: Color(0xFFF5F5F5),
    foregroundColor: Color(0xFF616161),
  ),
  moving(
    value: 'MOVING',
    label: 'Moving',
    icon: Icons.bolt,
    backgroundColor: Color(0xFFE8F5E9),
    foregroundColor: Color(0xFF2E7D32),
  ),
  stopped(
    value: 'STOPPED',
    label: 'Stopped',
    icon: Icons.pause_circle_outline,
    backgroundColor: Color(0xFFF5F5F5),
    foregroundColor: Color(0xFF616161),
  ),
  idle(
    value: 'IDLE',
    label: 'Idle',
    icon: Icons.pause,
    backgroundColor: Color(0xFFFFF8E1),
    foregroundColor: Color(0xFFF57F17),
  ),
  offline(
    value: 'OFFLINE',
    label: 'Offline',
    icon: Icons.wifi_off,
    backgroundColor: Color(0xFFFFEBEE),
    foregroundColor: Color(0xFFC62828),
  );

  const FleetStatus({
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  bool matches(FleetStatus  status) {
     return this == FleetStatus.all || this == status;
  }

  static FleetStatus fromValue(String value) {
    return FleetStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => FleetStatus.offline,
    );
  }
}

FleetStatus deriveVehicleStatus({
  required int? ignition,
  required double? speed,
  required DateTime? lastSeen,
}) {
  final isStale =
      lastSeen == null || DateTime.now().difference(lastSeen).inMinutes > 10;

  if (isStale) {
    return FleetStatus.offline;
  }

  if (speed != null && speed > 0.1) {
    return FleetStatus.moving;
  }

  if (speed != null && speed == 0 && ignition == 1) {
    return FleetStatus.idle;
  }

  return FleetStatus.stopped;
}
