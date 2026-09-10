import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/components/fleet_body.dart';
import 'package:flutter/material.dart';

class FleetFilterBar extends StatelessWidget {
  const FleetFilterBar({
    super.key,
    required this.vehicles,
    required this.statusByVehicle,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final List<VehicleEntity> vehicles;
  final Map<int, String> statusByVehicle;
  final FleetFilter activeFilter;
  final ValueChanged<FleetFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final statuses = vehicles.map((v) => statusByVehicle[v.id] ?? 'OFFLINE').toList();

    final counts = {
      FleetFilter.all: vehicles.length,
      FleetFilter.moving: statuses.where((s) => s == 'MOVING').length,
      FleetFilter.stopped: statuses.where((s) => s == 'STOPPED').length,
      FleetFilter.offline: statuses.where((s) => s == 'OFFLINE').length,
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: FleetFilter.values.map((filter) {
            final isActive = filter == activeFilter;
            final label = filter.name[0].toUpperCase() + filter.name.substring(1);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isActive,
                label: Text('$label (${counts[filter]})'),
                onSelected: (_) => onFilterChanged(filter),
                selectedColor: const Color(0xFF1A73E8).withOpacity(0.12),
                checkmarkColor: const Color(0xFF1A73E8),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? const Color(0xFF1A73E8) : Colors.grey.shade700,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}