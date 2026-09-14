import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/feature/geofence/domain/entities/geofence_entity.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/bloc/geofence/geofence_bloc.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/components/geofence_form_sheet.dart';
import 'package:bytebeam_assessment/feature/geofence/presentation/components/geofence_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeofenceView extends StatelessWidget {
  const GeofenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GeofenceBloc>()
        ..add(const GeofenceEvent.watch()),
      child: const _GeofenceView(),
    );
  }
}

class _GeofenceView extends StatelessWidget {
  const _GeofenceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => _showForm(context, null),
          ),
        ],
      ),
      body: BlocBuilder<GeofenceBloc, GeofenceState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg)),
            loaded: (geofences, counts, vehicleGeofences) {
              if (geofences.isEmpty) {
                return _EmptyGeofences(
                  onAdd: () => _showForm(context, null),
                );
              }

              final active = geofences.where((g) => g.isActive).toList();
              final inactive = geofences.where((g) => !g.isActive).toList();

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.horizontalspacing,
                  vertical: Dimens.verticalspacing,
                ),
                children: [
                  if (active.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Active',
                      count: active.length,
                    ),
                    SizedBox(height: Dimens.gapX2),
                    ...active.map(
                      (g) => Padding(
                        padding: EdgeInsets.only(bottom: Dimens.gapX3),
                        child: GeofenceTile(
                          geofence: g,
                          vehicleCount: counts[g.id] ?? 0,
                          onEdit: () => _showForm(context, g),
                          onToggle: () => context.read<GeofenceBloc>().add(
                                GeofenceEvent.toggle(
                                  id: g.id,
                                  isActive: false,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                  if (inactive.isNotEmpty) ...[
                    SizedBox(height: Dimens.gapX4),
                    _SectionHeader(
                      title: 'Deactivated',
                      count: inactive.length,
                    ),
                    SizedBox(height: Dimens.gapX2),
                    ...inactive.map(
                      (g) => Padding(
                        padding: EdgeInsets.only(bottom: Dimens.gapX3),
                        child: GeofenceTile(
                          geofence: g,
                          vehicleCount: 0,
                          onEdit: () => _showForm(context, g),
                          onToggle: () => context.read<GeofenceBloc>().add(
                                GeofenceEvent.toggle(
                                  id: g.id,
                                  isActive: true,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _showForm(BuildContext context, GeofenceEntity? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<GeofenceBloc>(),
        child: GeofenceFormSheet(existing: existing),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(width: Dimens.gapX2),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.horPaddingX2,
            vertical: Dimens.verPaddingX1,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(Dimens.radiusX10),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}

class _EmptyGeofences extends StatelessWidget {
  const _EmptyGeofences({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          SizedBox(height: Dimens.gapX4),
          Text(
            'No geofences yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: Dimens.gapX2),
          Text(
            'Create a boundary to track vehicle entry and exit',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.gapX6),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Geofence'),
          ),
        ],
      ),
    );
  }
}