import 'dart:async';

import 'package:bytebeam_assessment/config/routes/app_route_path.dart';
import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/fleet_alerts_summary.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/fleet_status/fleet_status_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/telemetry/telemetry_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fleet_empty_state.dart';
import 'fleet_filter_bar.dart';
import 'fleet_summary_bar.dart';
import 'vehicle_tile.dart';

class FleetBody extends StatefulWidget {
  const FleetBody({super.key});

  @override
  State<FleetBody> createState() => _FleetBodyState();
}

class _FleetBodyState extends State<FleetBody> {
  FleetStatus _activeStatus = FleetStatus.all;
  final Set<int> _visibleIds = {};
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onVisibilityChanged(int vehicleId, VisibilityInfo info) {
    final isVisible = info.visibleFraction > 0;
    final changed = isVisible
        ? _visibleIds.add(vehicleId)
        : _visibleIds.remove(vehicleId);
    if (!changed) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      context.read<TelemetryBloc>().add(
        TelemetryEvent.watch(_visibleIds.toList()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, vehicleState) {
        return vehicleState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          loaded: (vehicles) => BlocBuilder<FleetStatusBloc, FleetStatusState>(
            builder: (context, fleetStatusState) {
              final Map<int, FleetStatus> statusByVehicle = fleetStatusState
                  .maybeWhen(
                    loaded: (statusByVehicleId) => statusByVehicleId,
                    orElse: () => {},
                  );
              return BlocBuilder<TelemetryBloc, TelemetryState>(
                builder: (context, telemetryState) {
                  final detailByVehicle = telemetryState.maybeWhen(
                    loaded: (byVehicleId) => byVehicleId,
                    orElse: () => const <int, VehicleTelemetryEntity>{},
                  );
                  return _buildLoaded(
                    vehicles,
                    statusByVehicle,
                    detailByVehicle,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoaded(
    List<VehicleEntity> vehicles,
    Map<int, FleetStatus> statusByVehicle,
    Map<int, VehicleTelemetryEntity> detailByVehicle,
  ) {
    final filtered = _filter(vehicles, statusByVehicle);

    return Column(
      children: [
        const FleetAlertsSummary(),
        FleetSummaryBar(vehicles: vehicles, statusByVehicle: statusByVehicle),
        FleetFilterBar(
          vehicles: vehicles,
          statusByVehicle: statusByVehicle,
          activeStatus: _activeStatus,
          onStatusChanged: (status) {
            setState(() {
              _activeStatus = status;
            });
          },
        ),
        Expanded(
          child: filtered.isEmpty
              ? FleetEmptyState(filterLabel: _activeStatus.label)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final vehicle = filtered[index];
                    return VisibilityDetector(
                      key: Key('vehicle-visibility-${vehicle.id}'),
                      onVisibilityChanged: (info) =>
                          _onVisibilityChanged(vehicle.id, info),
                      child: VehicleTile(
                        vehicle: vehicle,
                        status:
                            statusByVehicle[vehicle.id] ?? FleetStatus.offline,
                        detail: detailByVehicle[vehicle.id],
                        onTap: () {
                          context.push(
                            AppRoutePath.detailsPage.path,
                            extra: vehicle,
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<VehicleEntity> _filter(
    List<VehicleEntity> vehicles,
    Map<int, FleetStatus> statusByVehicle,
  ) {
    return vehicles.where((vehicle) {
      final status = statusByVehicle[vehicle.id] ?? FleetStatus.offline;

      return _activeStatus.matches(status);
    }).toList();
  }
}
