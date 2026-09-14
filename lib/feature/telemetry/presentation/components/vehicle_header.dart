
import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/pages/details_view.dart';
import 'package:flutter/material.dart';

class VehicleHeader extends StatelessWidget {
  const VehicleHeader({
    super.key,
    required this.vehicle,
    required this.status,
    required this.telemetry,
  });
 
  final VehicleEntity vehicle;
  final FleetStatus status;
  final VehicleTelemetryEntity telemetry;
 
  @override
  Widget build(BuildContext context) {
    final hasLocation =
        telemetry.latitude != null && telemetry.longitude != null;
 
    final locationText = hasLocation
        ? '${telemetry.latitude!.toStringAsFixed(4)}°N, '
              '${telemetry.longitude!.toStringAsFixed(4)}°E'
        : 'Location unknown';
 
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 104,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              size: 54,
              color: Color(0xFF34495E),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.registration,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.model,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),
                VehicleStatusChip(status: status),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}