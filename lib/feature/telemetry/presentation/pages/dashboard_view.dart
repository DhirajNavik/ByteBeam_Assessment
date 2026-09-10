import 'dart:async';

import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/core/database/duck_db_seeder.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/fleet_status/fleet_status_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/telemetry/telemetry_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle/vehicle_bloc.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/components/fleet_body.dart';
import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          _Phase.running => const FleetBody(),
        },
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
