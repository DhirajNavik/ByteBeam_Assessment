import 'package:bytebeam_assessment/core/extension/context_extension.dart';
import 'package:bytebeam_assessment/core/utils/app_palettes.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/vehicle_geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/bloc/geofence/geofence_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleGeofenceBadge extends StatelessWidget {
  const VehicleGeofenceBadge({super.key, required this.vehicleId});

  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeofenceBloc, GeofenceState>(
      builder: (context, state) {
        final memberships = state.maybeWhen(
          loaded: (_, _, vehicleGeofences) => vehicleGeofences
              .where((v) => v.vehicleId == vehicleId)
              .toList(),
          orElse: () => <VehicleGeofenceEntity>[],
        );

        if (memberships.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.horPaddingX4,
            vertical: Dimens.verPaddingX2,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacityExt(0.07),
            borderRadius: BorderRadius.circular(Dimens.radiusX3),
            border: Border.all(
              color: context.colorScheme.primary.withOpacityExt(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.radar_rounded,
                size: Dimens.scaleX3,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: Dimens.gapX2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inside geofence',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Dimens.gapX1),
                    ...memberships.map(
                      (m) => Text(
                        m.geofenceName,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}