import 'package:flutter/material.dart';

enum VehicleStatus { moving, idle, stopped, offline }

extension VehicleStatusExtension on String {
  VehicleStatus toVehicleStatus() {
    switch (this) {
      case 'MOVING':  return VehicleStatus.moving;
      case 'IDLE':    return VehicleStatus.idle;
      case 'STOPPED': return VehicleStatus.stopped;
      default:        return VehicleStatus.offline;
    }
  }
}

class VehicleStatusChip extends StatelessWidget {
  final String status;

  const VehicleStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final vehicleStatus = status.toVehicleStatus();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(vehicleStatus),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _foregroundColor(vehicleStatus),
        ),
      ),
    );
  }

  Color _backgroundColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.moving:  return const Color(0xFFE8F5E9);
      case VehicleStatus.idle:    return const Color(0xFFFFF8E1);
      case VehicleStatus.stopped: return const Color(0xFFF5F5F5);
      case VehicleStatus.offline: return const Color(0xFFFFEBEE);
    }
  }

  Color _foregroundColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.moving:  return const Color(0xFF2E7D32);
      case VehicleStatus.idle:    return const Color(0xFFF57F17);
      case VehicleStatus.stopped: return const Color(0xFF616161);
      case VehicleStatus.offline: return const Color(0xFFC62828);
    }
  }
}