import 'package:flutter/material.dart';

enum VehicleStatus { moving, stopped, offline }

extension VehicleStatusExtension on String {
  VehicleStatus toVehicleStatus() => switch (this) {
    'MOVING' => VehicleStatus.moving,
    'STOPPED' => VehicleStatus.stopped,
    _ => VehicleStatus.offline,
  };
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon(vehicleStatus),
            size: 11,
            color: _foregroundColor(vehicleStatus),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _foregroundColor(vehicleStatus),
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(VehicleStatus status) => switch (status) {
    VehicleStatus.moving => Icons.bolt,
    VehicleStatus.stopped => Icons.pause_circle_outline,
    VehicleStatus.offline => Icons.wifi_off,
  };

  Color _backgroundColor(VehicleStatus status) => switch (status) {
    VehicleStatus.moving => const Color(0xFFE8F5E9),
    VehicleStatus.stopped => const Color(0xFFF5F5F5),
    VehicleStatus.offline => const Color(0xFFFFEBEE),
  };

  Color _foregroundColor(VehicleStatus status) => switch (status) {
    VehicleStatus.moving => const Color(0xFF2E7D32),
    VehicleStatus.stopped => const Color(0xFF616161),
    VehicleStatus.offline => const Color(0xFFC62828),
  };
}
