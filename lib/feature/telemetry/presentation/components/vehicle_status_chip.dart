import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:flutter/material.dart';

class VehicleStatusChip extends StatelessWidget {
  final FleetStatus status;
  const VehicleStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 11, color: status.foregroundColor),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
