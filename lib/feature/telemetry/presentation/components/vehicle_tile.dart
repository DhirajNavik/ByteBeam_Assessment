import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/components/vehicle_status_chip.dart';
import 'package:flutter/material.dart';

class VehicleTile extends StatelessWidget {
  const VehicleTile({
    super.key,
    required this.vehicle,
    required this.status,
    required this.detail,
    required this.onTap,
  });

  final VehicleEntity vehicle;
  final String status; // from fleet-wide stream — always correct
  final VehicleTelemetryEntity? detail; // from visible-only stream — may be null
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasAlert = detail?.hasAlert ?? false;
    final isCritical = detail?.isCritical ?? false;
    final accentColor = switch (status) {
      'MOVING' => const Color(0xFF2E7D32),
      'STOPPED' => const Color(0xFF9E9E9E),
      _ => const Color(0xFFC62828),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accentColor),
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vehicle.registration,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasAlert) ...[
                            _AlertBadge(isCritical: isCritical),
                            const SizedBox(width: 8),
                          ],
                          VehicleStatusChip(status: status),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(vehicle.model, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      const SizedBox(height: 12),
                      _SignalGrid(detail: detail, hasAlert: hasAlert, isCritical: isCritical),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalGrid extends StatelessWidget {
  const _SignalGrid({required this.detail, required this.hasAlert, required this.isCritical});

  final VehicleTelemetryEntity? detail;
  final bool hasAlert;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _SignalTile(label: 'SOC', value: _fmt(detail?.soc, '%'), isAlert: hasAlert, isCritical: isCritical),
            _SignalTile(label: 'Speed', value: _fmt(detail?.speed, ' km/h', decimals: 0)),
            _SignalTile(label: 'Range', value: _fmt(detail?.range, ' km', decimals: 0)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _SignalTile(label: 'Temp', value: _fmt(detail?.batteryTemp, '°C')),
            _SignalTile(label: 'Odo', value: _fmt(detail?.odometer, ' km', decimals: 0)),
            _SignalTile(label: 'Last ping', value: _formatPing(detail?.lastPingAt)),
          ],
        ),
      ],
    );
  }

  String _fmt(double? value, String unit, {int decimals = 1}) =>
      value == null ? '—' : '${value.toStringAsFixed(decimals)}$unit';

  String _formatPing(DateTime? lastPingAt) {
    if (lastPingAt == null) return '—';
    final diff = DateTime.now().difference(lastPingAt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({required this.label, required this.value, this.isAlert = false, this.isCritical = false});
  final String label;
  final String value;
  final bool isAlert;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final valueColor = isCritical
        ? const Color(0xFFC62828)
        : isAlert
            ? const Color(0xFFF57F17)
            : const Color(0xFF212121);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.isCritical});
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final color = isCritical ? const Color(0xFFC62828) : const Color(0xFFF57F17);
    final bg = isCritical ? const Color(0xFFFFEBEE) : const Color(0xFFFFF8E1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 12, color: color),
          const SizedBox(width: 3),
          Text(isCritical ? 'Critical' : 'Warning',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}