// import 'package:flutter/material.dart';
// import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
// import 'vehicle_status_chip.dart';

// class VehicleCard extends StatelessWidget {
//   final VehicleEntity vehicle;
//   final VoidCallback onTap;

//   const VehicleCard({
//     super.key,
//     required this.vehicle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top row: reg number + alert badge + status chip
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       vehicle.registration,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   if (vehicle.hasAlert) _AlertBadge(isCritical: vehicle.isCritical),
//                   const SizedBox(width: 8),
//                   VehicleStatusChip(status: vehicle.status),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 vehicle.model,
//                 style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//               ),
//               const SizedBox(height: 12),

//               // Signal tiles row
//               Row(
//                 children: [
//                   _SignalTile(
//                     label: 'SOC',
//                     value: vehicle.soc != null
//                         ? '${vehicle.soc!.toStringAsFixed(1)}%'
//                         : '—',
//                     isAlert: vehicle.hasAlert,
//                     isCritical: vehicle.isCritical,
//                   ),
//                   _SignalTile(
//                     label: 'Range',
//                     value: vehicle.range != null
//                         ? '${vehicle.range!.toStringAsFixed(0)} km'
//                         : '—',
//                   ),
//                   _SignalTile(
//                     label: 'Speed',
//                     value: vehicle.speed != null
//                         ? '${vehicle.speed!.toStringAsFixed(0)} km/h'
//                         : '—',
//                   ),
//                   _SignalTile(
//                     label: 'Temp',
//                     value: vehicle.batteryTemp != null
//                         ? '${vehicle.batteryTemp!.toStringAsFixed(1)}°C'
//                         : '—',
//                   ),
//                   _SignalTile(
//                     label: 'Last ping',
//                     value: _formatPing(vehicle.lastPingAt),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatPing(DateTime? lastPingAt) {
//     if (lastPingAt == null) return '—';
//     final diff = DateTime.now().difference(lastPingAt);
//     if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     return '${diff.inHours}h ago';
//   }
// }

// // ---------------------------------------------------------------------------
// // Alert badge
// // ---------------------------------------------------------------------------

// class _AlertBadge extends StatelessWidget {
//   final bool isCritical;
//   const _AlertBadge({required this.isCritical});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//       decoration: BoxDecoration(
//         color: isCritical
//             ? const Color(0xFFFFEBEE)
//             : const Color(0xFFFFF8E1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.warning_amber_rounded,
//             size: 12,
//             color: isCritical
//                 ? const Color(0xFFC62828)
//                 : const Color(0xFFF57F17),
//           ),
//           const SizedBox(width: 3),
//           Text(
//             isCritical ? 'Critical' : 'Warning',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: isCritical
//                   ? const Color(0xFFC62828)
//                   : const Color(0xFFF57F17),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------------------------
// // Signal tile
// // ---------------------------------------------------------------------------

// class _SignalTile extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isAlert;
//   final bool isCritical;

//   const _SignalTile({
//     required this.label,
//     required this.value,
//     this.isAlert = false,
//     this.isCritical = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final valueColor = isCritical
//         ? const Color(0xFFC62828)
//         : isAlert
//             ? const Color(0xFFF57F17)
//             : null;

//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: valueColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }