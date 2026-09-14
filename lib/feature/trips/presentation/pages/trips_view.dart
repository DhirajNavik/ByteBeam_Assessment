import 'package:bytebeam_assessment/core/extension/date_time_formatter.dart';
import 'package:bytebeam_assessment/feature/trips/domain/entities/trip_entity.dart';
import 'package:bytebeam_assessment/feature/trips/presentation/trips/trips_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trips')),
      body: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: (trips) {
              if (trips.isEmpty) {
                return const Center(child: Text('No trips yet'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _TripTile(trip: trips[i]),
              );
            },
          );
        },
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  const _TripTile({required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    final inProgress = trip.isInProgress;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            inProgress ? Icons.pending_outlined : Icons.check_circle_outline,
            color: inProgress ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle #${trip.vehicleId}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${trip.originGeofenceName} → '
                  '${trip.destinationGeofenceName ?? "…"}',
                ),
                Text(
                  inProgress
                      ? 'Started ${trip.startedAt.toRelativeTime()}'
                      : 'Completed ${trip.completedAt!.toRelativeTime()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}