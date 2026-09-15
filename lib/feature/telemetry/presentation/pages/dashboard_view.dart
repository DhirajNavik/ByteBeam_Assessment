import 'dart:async';
import 'dart:developer';

import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/config/routes/app_route_path.dart';
import 'package:bytebeam_assessment/core/components/common_snackbar.dart';
import 'package:bytebeam_assessment/core/database/duck_db_seeder.dart';
import 'package:bytebeam_assessment/core/database/seeds/backfll.seeder.dart';
import 'package:bytebeam_assessment/core/database/seeds/telemetry.seeder.dart';
import 'package:bytebeam_assessment/core/database/utils/retention_policy.dart';
import 'package:bytebeam_assessment/core/database/utils/scale_benchmark.dart';
import 'package:bytebeam_assessment/core/network/database_requester.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/fleet_status/fleet_status_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/telemetry/telemetry_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/components/fleet_body.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FleetHomePage extends StatefulWidget {
  const FleetHomePage({super.key});

  @override
  State<FleetHomePage> createState() => _FleetHomePageState();
}

enum _Phase { seeding, running, error }

class _FleetHomePageState extends State<FleetHomePage> {
  late final VehicleBloc _vehicleBloc;
  late final TelemetryBloc _telemetryBloc;
  late final FleetStatusBloc _fleetStatusBloc;

  _Phase _phase = _Phase.seeding;
  String _errorMessage = '';

  /// Guards the debug scale actions so a second tap can't run concurrently
  /// with the first and corrupt the measurement.
  bool _debugTaskRunning = false;
  double _backfillProgress = 0;

  @override
  void initState() {
    super.initState();
    _vehicleBloc = serviceLocator<VehicleBloc>();
    _telemetryBloc = serviceLocator<TelemetryBloc>();
    _fleetStatusBloc = serviceLocator<FleetStatusBloc>();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final connection = serviceLocator<Connection>();
      await DuckDBSeeder.createSeed(connection);

      // Retention runs once per launch, before the UI starts querying, so an
      // append-only log can't grow unbounded across sessions. Idempotent —
      // see RetentionPolicy.
      await RetentionPolicy.compact(connection);
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
    _fleetStatusBloc.add(const FleetStatusEvent.watch());
    context.read<AlertsBloc>().add(const AlertsEvent.watch());
  }

  // ── Debug scale actions ───────────────────────────────────────────────────
  // Present only in debug builds; they exist to produce the section-4
  // numbers, not as product features.

  Future<void> _runBackfill() async {
    if (_debugTaskRunning) return;
    setState(() {
      _debugTaskRunning = true;
      _backfillProgress = 0;
    });
    final connection = serviceLocator<Connection>();
    TelemetrySeeder.stop();
    try {
      final report = await BackfillSeeder.run(
        connection,
        onProgress: (progress) {
          if (mounted) setState(() => _backfillProgress = progress);
        },
      );
      _showResult(report.toString());
    } catch (e) {
      _showResult('Backfill failed: $e');
    } finally {
      unawaited(TelemetrySeeder.start(connection));
      if (mounted) setState(() => _debugTaskRunning = false);
    }
  }

  Future<void> _runBenchmark() async {
    if (_debugTaskRunning) return;
    setState(() => _debugTaskRunning = true);

    try {
      final database = serviceLocator<DatabaseRequester>();
      final summary = await ScaleBenchmark.runAll(database, sampleVehicleId: 1);
      _showResult(summary);
    } catch (e) {
      _showResult('Benchmark failed: $e');
    } finally {
      if (mounted) setState(() => _debugTaskRunning = false);
    }
  }

  Future<void> _runRetention() async {
    if (_debugTaskRunning) return;
    setState(() => _debugTaskRunning = true);

    try {
      final connection = serviceLocator<Connection>();
      final report = await RetentionPolicy.compact(connection);
      _showResult(report.toString());
    } catch (e) {
      _showResult('Retention failed: $e');
    } finally {
      if (mounted) setState(() => _debugTaskRunning = false);
    }
  }

  /// Results go to a dialog as well as debugPrint, so the numbers can be read
  /// off a physical device that isn't attached to a console.
  void _showResult(String message) {
    log(message);
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Scale exercise'),
        content: SingleChildScrollView(
          child: SelectableText(
            message,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _vehicleBloc.close();
    _telemetryBloc.close();
    _fleetStatusBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _vehicleBloc),
        BlocProvider.value(value: _telemetryBloc),
        BlocProvider.value(value: _fleetStatusBloc),
      ],
      child: BlocListener<AlertsBloc, AlertsState>(
        listenWhen: (p, c) {
          final prevId = p.whenOrNull(loaded: (_, id) => id);
          final currId = c.whenOrNull(loaded: (_, id) => id);
          return currId != null && currId != prevId;
        },
        listener: (context, state) {
          CommonSnackbar.showUndoToast(
            context,
            message: 'Alert dismissed',
            onUndo: () {
              context.read<AlertsBloc>().add(
                AlertsEvent.undoDismiss(
                  state.whenOrNull(loaded: (_, id) => id)!,
                ),
              );
            },
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'Fleet Console',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                onPressed: _debugTaskRunning ? null : _runBackfill,
                icon: const Icon(Icons.dataset_outlined),
                tooltip: 'Backfill 2M rows',
              ),
              IconButton(
                onPressed: _debugTaskRunning ? null : _runBenchmark,
                icon: const Icon(Icons.timer_outlined),
                tooltip: 'Benchmark queries',
              ),
              IconButton(
                onPressed: _debugTaskRunning ? null : _runRetention,
                icon: const Icon(Icons.compress),
                tooltip: 'Run retention/compaction',
              ),
              IconButton(
                onPressed: () => context.push(AppRoutePath.geofencePage.path),
                icon: const Icon(Icons.radar_rounded),
                tooltip: 'Geofences',
              ),
              IconButton(
                onPressed: () => context.push(AppRoutePath.alertsPage.path),
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Alerts',
              ),
            ],
            bottom: _debugTaskRunning
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(3),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      value: _backfillProgress == 0 ? null : _backfillProgress,
                    ),
                  )
                : null,
          ),
          body: switch (_phase) {
            _Phase.seeding => const _SeedingView(),
            _Phase.error => _ErrorView(message: _errorMessage),
            _Phase.running => const FleetBody(),
          },
        ),
      ),
    );
  }
}

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
