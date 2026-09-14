import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/app_palettes.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:flutter/material.dart';

class GeofenceTile extends StatelessWidget {
  const GeofenceTile({
    super.key,
    required this.geofence,
    required this.vehicleCount,
    required this.onEdit,
    required this.onToggle,
  });

  final GeofenceEntity geofence;
  final int vehicleCount;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isActive = geofence.isActive;
    final accentColor = isActive
        ? context.colorScheme.primary
        : context.colorScheme.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(Dimens.radiusX4),
        border: Border.all(
          color: isActive
              ? context.colorScheme.primary.withOpacityExt(0.18)
              : context.colorScheme.outline.withOpacityExt(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimens.allPaddingX4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacityExt(0.12),
                    borderRadius: BorderRadius.circular(Dimens.radiusX3),
                  ),
                  child: Icon(
                    Icons.radar_rounded,
                    color: accentColor,
                    size: Dimens.scaleX3,
                  ),
                ),
                SizedBox(width: Dimens.gapX3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              geofence.name,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? context.colorScheme.onSurface
                                    : context.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _StatusBadge(isActive: isActive),
                        ],
                      ),
                      SizedBox(height: Dimens.gapX1),
                      Text(
                        '${_formatRadius(geofence.radiusMeters)} radius',
                        style: context.textTheme.bodySmall,
                      ),
                      SizedBox(height: Dimens.gapX1),
                      Text(
                        '${geofence.latitude.toStringAsFixed(4)}°, '
                        '${geofence.longitude.toStringAsFixed(4)}°',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: context.colorScheme.outline.withOpacityExt(0.3),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.horPaddingX4,
              vertical: Dimens.verPaddingX2,
            ),
            child: Row(
              children: [
                if (isActive) ...[
                  Icon(
                    Icons.local_shipping_outlined,
                    size: Dimens.scaleX2,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: Dimens.gapX1B),
                  Text(
                    '$vehicleCount ${vehicleCount == 1 ? 'vehicle' : 'vehicles'} inside',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else
                  Text(
                    'Retained for trip history',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.horPaddingX3,
                      vertical: Dimens.verPaddingX1,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Edit'),
                ),
                SizedBox(width: Dimens.gapX1),
                TextButton(
                  onPressed: onToggle,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.horPaddingX3,
                      vertical: Dimens.verPaddingX1,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: isActive
                        ? context.colorScheme.error
                        : context.colorScheme.primary,
                  ),
                  child: Text(isActive ? 'Deactivate' : 'Activate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRadius(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.horPaddingX2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFE8F5E9)
            : context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(Dimens.radiusX10),
      ),
      child: Text(
        isActive ? 'Active' : 'Off',
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isActive
              ? const Color(0xFF2E7D32)
              : context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}