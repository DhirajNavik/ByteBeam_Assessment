import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:flutter/material.dart';

class FleetFilterBar extends StatelessWidget {
  const FleetFilterBar({
    super.key,
    required this.vehicles,
    required this.statusByVehicle,
    required this.activeStatus,
    required this.onStatusChanged,
  });

  final List<VehicleEntity> vehicles;
  final Map<int, FleetStatus> statusByVehicle;
  final FleetStatus activeStatus;
  final ValueChanged<FleetStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final counts = <FleetStatus, int>{
      for (final status in FleetStatus.values)
        status: status == FleetStatus.all
            ? vehicles.length
            : vehicles
                  .where((vehicle) => statusByVehicle[vehicle.id] == status)
                  .length,
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: FleetStatus.values.map((status) {
            final isActive = status == activeStatus;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isActive,
                label: Text('${status.label} (${counts[status]})'),
                onSelected: (_) => onStatusChanged(status),
                selectedColor: const Color(0xFF1A73E8).withOpacity(0.12),
                checkmarkColor: const Color(0xFF1A73E8),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF1A73E8)
                      : Colors.grey.shade700,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
