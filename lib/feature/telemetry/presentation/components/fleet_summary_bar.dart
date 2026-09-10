import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:flutter/material.dart';

class FleetSummaryBar extends StatelessWidget {
  const FleetSummaryBar({
    super.key,
    required this.vehicles,
    required this.statusByVehicle,
  });

  final List<VehicleEntity> vehicles;
  final Map<int, FleetStatus> statusByVehicle;

  @override
  Widget build(BuildContext context) {
    final statuses = vehicles.map(
      (vehicle) => statusByVehicle[vehicle.id] ?? FleetStatus.offline,
    );
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _StatItem(
            label: 'Fleet',
            value: '${vehicles.length}',
            color: const Color(0xFF616161),
          ),
          ...FleetStatus.values
              .where((status) => status != FleetStatus.all)
              .map(
                (status) => _StatItem(
                  label: status.label,
                  value: '${statuses.where((s) => s == status).length}',
                  color: status.foregroundColor,
                ),
              ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
