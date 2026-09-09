import 'dart:async';

import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/core/database/duck_db_seeder.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/telemetry/telemetry_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/components/vehicle_status_chip.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum FleetFilter { all, moving, idle, stopped, offline }

// ---------------------------------------------------------------------------
// Fleet Home Page
// ---------------------------------------------------------------------------

class FleetHomePage extends StatefulWidget {
  const FleetHomePage({super.key});

  @override
  State<FleetHomePage> createState() => _FleetHomePageState();
}

enum _Phase { seeding, running, error }

class _FleetHomePageState extends State<FleetHomePage> {
  late final VehicleBloc _vehicleBloc;
  late final TelemetryBloc _telemetryBloc;

  _Phase _phase = _Phase.seeding;
  String _errorMessage = '';

  // Which vehicle ids TelemetryBloc is currently watching. VehicleState.loaded
  // can fire more than once (e.g. a future manual refresh); we only want to
  // restart the telemetry stream if the id set actually changed.
  List<int> _watchedIds = const [];

  @override
  void initState() {
    super.initState();
    _vehicleBloc = serviceLocator<VehicleBloc>();
    _telemetryBloc = serviceLocator<TelemetryBloc>();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final connection = serviceLocator<Connection>();
      await DuckDBSeeder.createSeed(connection);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.error;
        _errorMessage = 'Failed to prepare database: $e';
      });
      return;
    }

    if (!mounted) return;
    setState(() => _phase = _Phase.running);
    _vehicleBloc.add(const VehicleEvent.fetchVehicles());
  }

  void _onVehiclesLoaded(List<VehicleEntity> vehicles) {
    final ids = vehicles.map((v) => v.id).toList();
    if (_sameIds(ids, _watchedIds)) return;
    _watchedIds = ids;
    _telemetryBloc.add(TelemetryEvent.watch(ids));
  }

  bool _sameIds(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _vehicleBloc.close();
    _telemetryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _vehicleBloc),
        BlocProvider.value(value: _telemetryBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'Fleet Console',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: switch (_phase) {
          _Phase.seeding => const _SeedingView(),
          _Phase.error => _ErrorView(message: _errorMessage),
          _Phase.running => const _FleetBody(),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Seeding / error views
// ---------------------------------------------------------------------------

class _SeedingView extends StatelessWidget {
  const _SeedingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              size: 56,
              color: Color(0xFF1A73E8),
            ),
            const SizedBox(height: 24),
            Text(
              'Fleet Console',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Preparing local database…',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: LinearProgressIndicator(minHeight: 8),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fleet body — merges VehicleBloc + TelemetryBloc
// ---------------------------------------------------------------------------

class _FleetBody extends StatefulWidget {
  const _FleetBody();

  @override
  State<_FleetBody> createState() => _FleetBodyState();
}

class _FleetBodyState extends State<_FleetBody> {
  FleetFilter _activeFilter = FleetFilter.all;
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

    // Debounce: fast scrolling fires this constantly — only push the id
    // set to TelemetryBloc once it settles for a moment.
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
          loaded: (vehicles) => BlocBuilder<TelemetryBloc, TelemetryState>(
            builder: (context, telemetryState) {
              final byId = telemetryState.maybeWhen(
                loaded: (byVehicleId) => byVehicleId,
                orElse: () => const <int, VehicleTelemetryEntity>{},
              );
              return _buildLoaded(vehicles, byId);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoaded(
    List<VehicleEntity> vehicles,
    Map<int, VehicleTelemetryEntity> telemetryByVehicle,
  ) {
    final filtered = _filter(vehicles, telemetryByVehicle);

    return Column(
      children: [
        _FilterBar(
          vehicles: vehicles,
          telemetryByVehicle: telemetryByVehicle,
          activeFilter: _activeFilter,
          onFilterChanged: (f) => setState(() => _activeFilter = f),
        ),
        Expanded(
          child: filtered.isEmpty
              ? _EmptyState(filter: _activeFilter)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final vehicle = filtered[index];
                    return VisibilityDetector(
                      key: Key('vehicle-visibility-${vehicle.id}'),
                      onVisibilityChanged: (info) =>
                          _onVisibilityChanged(vehicle.id, info),
                      child: _VehicleTile(
                        vehicle: vehicle,
                        telemetry: telemetryByVehicle[vehicle.id],
                        onTap: () {
                          // TODO: navigate to vehicle detail
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
    Map<int, VehicleTelemetryEntity> telemetryByVehicle,
  ) {
    if (_activeFilter == FleetFilter.all) return vehicles;
    final wanted = _filterStatus(_activeFilter);
    return vehicles
        .where((v) => _statusOf(telemetryByVehicle[v.id]) == wanted)
        .toList();
  }
}

String _filterStatus(FleetFilter filter) => switch (filter) {
  FleetFilter.moving => 'MOVING',
  FleetFilter.idle => 'IDLE',
  FleetFilter.stopped => 'STOPPED',
  FleetFilter.offline || FleetFilter.all => 'OFFLINE',
};

/// Status shown for a vehicle given its latest telemetry. See note below —
/// this currently just echoes whatever `VehicleTelemetryEntity.status`
/// contains, because that's the data layer's job, not the view's.
String _statusOf(VehicleTelemetryEntity? telemetry) =>
    telemetry?.status.toUpperCase() ?? 'OFFLINE';

// ---------------------------------------------------------------------------
// Filter chip bar
// ---------------------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.vehicles,
    required this.telemetryByVehicle,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final List<VehicleEntity> vehicles;
  final Map<int, VehicleTelemetryEntity> telemetryByVehicle;
  final FleetFilter activeFilter;
  final ValueChanged<FleetFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final statuses = vehicles
        .map((v) => _statusOf(telemetryByVehicle[v.id]))
        .toList();

    final counts = {
      FleetFilter.all: vehicles.length,
      FleetFilter.moving: statuses.where((s) => s == 'MOVING').length,
      FleetFilter.idle: statuses.where((s) => s == 'IDLE').length,
      FleetFilter.stopped: statuses.where((s) => s == 'STOPPED').length,
      FleetFilter.offline: statuses.where((s) => s == 'OFFLINE').length,
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: FleetFilter.values.map((filter) {
            final isActive = filter == activeFilter;
            final label =
                filter.name[0].toUpperCase() + filter.name.substring(1);

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

// ---------------------------------------------------------------------------
// Vehicle tile (replaces the dead vehicle_card.dart)
// ---------------------------------------------------------------------------

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({
    required this.vehicle,
    required this.telemetry,
    required this.onTap,
  });

  final VehicleEntity vehicle;
  final VehicleTelemetryEntity? telemetry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusOf(telemetry);
    final hasAlert = telemetry?.hasAlert ?? false;
    final isCritical = telemetry?.isCritical ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vehicle.registration,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hasAlert) _AlertBadge(isCritical: isCritical),
                  const SizedBox(width: 8),
                  VehicleStatusChip(status: status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                vehicle.model,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _SignalTile(
                    label: 'SOC',
                    value: _fmt(telemetry?.soc, '%'),
                    isAlert: hasAlert,
                    isCritical: isCritical,
                  ),
                  _SignalTile(
                    label: 'Range',
                    value: _fmt(telemetry?.range, ' km', decimals: 0),
                  ),
                  _SignalTile(
                    label: 'Speed',
                    value: _fmt(telemetry?.speed, ' km/h', decimals: 0),
                  ),
                   _SignalTile(
                    label: 'Odo',
                    value: _fmt(telemetry?.odometer, '°C',decimals: 0),
                  ),
                  _SignalTile(
                    label: 'Temp',
                    value: _fmt(telemetry?.batteryTemp, '°C'),
                  ),
                  _SignalTile(
                    label: 'Last ping',
                    value: _formatPing(telemetry?.lastPingAt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(double? value, String unit, {int decimals = 1}) {
    if (value == null) return '—';
    return '${value.toStringAsFixed(decimals)}$unit';
  }

  String _formatPing(DateTime? lastPingAt) {
    if (lastPingAt == null) return '—';
    final diff = DateTime.now().difference(lastPingAt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.isCritical});
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final color = isCritical
        ? const Color(0xFFC62828)
        : const Color(0xFFF57F17);
    final bg = isCritical ? const Color(0xFFFFEBEE) : const Color(0xFFFFF8E1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            isCritical ? 'Critical' : 'Warning',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({
    required this.label,
    required this.value,
    this.isAlert = false,
    this.isCritical = false,
  });

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
        : null;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});
  final FleetFilter filter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No ${filter.name} vehicles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
