import 'package:bytebeam_assessment/config/injectors/injectable.dart';
import 'package:bytebeam_assessment/core/utils/dimens.dart';
import 'package:bytebeam_assessment/core/utils/vehicle_status.dart';
import 'package:bytebeam_assessment/feature/alerts/domain/entities/alert_entity.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/bloc/alerts/alerts_bloc.dart';
import 'package:bytebeam_assessment/feature/alerts/presentation/components/alert_tile.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/soc_history_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/domain/entities/vehicle_telemetry_entity.dart';
import 'package:bytebeam_assessment/feature/telemetry/presentation/bloc/vehicle_details/vehicle_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetailPage extends StatelessWidget {
  const VehicleDetailPage({super.key, required this.vehicle});

  final VehicleEntity vehicle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VehicleDetailsBloc>()
        ..add(VehicleDetailsEvent.watch(vehicleId: vehicle.id))
        ..add(VehicleDetailsEvent.watchHistory(vehicleId: vehicle.id)),

      child: _VehicleDetailView(vehicle: vehicle),
    );
  }
}

class _VehicleDetailView extends StatelessWidget {
  const _VehicleDetailView({required this.vehicle});

  final VehicleEntity vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<VehicleDetailsBloc, VehicleDetailsState>(
          builder: (context, state) {
            return state.when(
              initial: () {
                return const SizedBox.shrink();
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              loaded: (telemetry, history) {
                return _buildLoaded(
                  vehicle: vehicle,
                  telemetry: telemetry,
                  history: history,
                );
              },
              error: (message) {
                return _buildError(context, message);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoaded({
    required VehicleEntity vehicle,
    required List<SOCHistoryEntity> history,
    required VehicleTelemetryEntity? telemetry,
  }) {
    if (telemetry == null) {
      return SizedBox.shrink();
    }
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.horizontalspacing,
        vertical: Dimens.verticalspacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.widgetSpacing,
        children: [
          _VehicleHeader(vehicle: vehicle, status: telemetry.status),
          BlocBuilder<AlertsBloc, AlertsState>(
            builder: (context, state) {
              final alerts = state.maybeWhen(
                loaded: (all, _) =>
                    all.where((a) => a.vehicleId == vehicle.id).toList(),
                orElse: () => const <AlertEntity>[],
              );
              return Column(
                spacing: Dimens.gapX2,
                children: alerts.map((e) => AlertTile(alert: e)).toList(),
              );
            },
          ),

          _OverviewSection(telemetry: telemetry),
          _SectionTitle(
            title: 'Live Location',
            trailing: telemetry.lastPingAt == null
                ? null
                : _formatAge(telemetry.lastPingAt!),
          ),
          const _LiveLocationCard(),
          const _SectionTitle(title: 'SOC History'),
          _SocHistoryCard(values: history),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<VehicleDetailsBloc>().add(
                  VehicleDetailsEvent.watch(vehicleId: vehicle.id),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Vehicle header
// -----------------------------------------------------------------------------

class _VehicleHeader extends StatelessWidget {
  const _VehicleHeader({required this.vehicle, required this.status});

  final VehicleEntity vehicle;
  final FleetStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 104,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              size: 54,
              color: Color(0xFF34495E),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.registration,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.model,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),
                VehicleStatusChip(status: status),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Near Whitefield, Bengaluru',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Overview
// -----------------------------------------------------------------------------

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.telemetry});

  final VehicleTelemetryEntity telemetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Overview'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.75,
          children: [
            _ReadingCard(
              icon: Icons.battery_full,
              label: 'SOC',
              value: _formatPercent(telemetry.soc),
              verdict: _socVerdict(telemetry),
            ),
            _ReadingCard(
              icon: Icons.route_outlined,
              label: 'Range',
              value: _formatValue(telemetry.range, suffix: ' km'),
              verdict: _normalVerdict(telemetry),
            ),
            _ReadingCard(
              icon: Icons.speed_outlined,
              label: 'Speed',
              value: _formatValue(telemetry.speed, suffix: ' km/h'),
              verdict: _normalVerdict(telemetry),
            ),
            _ReadingCard(
              icon: Icons.thermostat_outlined,
              label: 'Battery Temp',
              value: _formatValue(telemetry.batteryTemp, suffix: '°C'),
              verdict: _temperatureVerdict(telemetry),
            ),
            _ReadingCard(
              icon: Icons.speed,
              label: 'Odometer',
              value: _formatValue(telemetry.odometer, suffix: ' km'),
              verdict: _normalVerdict(telemetry),
            ),
            _ReadingCard(
              icon: Icons.access_time,
              label: 'Last Ping',
              value: telemetry.lastPingAt == null
                  ? '—'
                  : _formatAge(telemetry.lastPingAt!),
              verdict: _pingVerdict(telemetry),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Reading card
// -----------------------------------------------------------------------------

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.verdict,
  });

  final IconData icon;
  final String label;
  final String value;
  final _SignalVerdict verdict;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                _VerdictPill(verdict: verdict),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Verdict
// -----------------------------------------------------------------------------

enum _SignalVerdictType { normal, alert, stale, none }

class _SignalVerdict {
  const _SignalVerdict({required this.type, required this.label});

  final _SignalVerdictType type;
  final String label;
}

class _VerdictPill extends StatelessWidget {
  const _VerdictPill({required this.verdict});

  final _SignalVerdict verdict;

  @override
  Widget build(BuildContext context) {
    if (verdict.type == _SignalVerdictType.none) {
      return const SizedBox.shrink();
    }

    final isAlert = verdict.type == _SignalVerdictType.alert;
    final isStale = verdict.type == _SignalVerdictType.stale;

    final background = isStale
        ? const Color(0xFFF1F3F5)
        : isAlert
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFE8F5E9);

    final foreground = isStale
        ? const Color(0xFF757575)
        : isAlert
        ? const Color(0xFFC62828)
        : const Color(0xFF2E7D32);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        verdict.label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Live location
// -----------------------------------------------------------------------------

class _LiveLocationCard extends StatelessWidget {
  const _LiveLocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E6EC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            color: const Color(0xFFDDE7D9),
            child: CustomPaint(
              painter: _MapPlaceholderPainter(),
              size: Size.infinite,
            ),
          ),
          const Positioned(
            left: 20,
            top: 18,
            child: _MapBadge(
              icon: Icons.location_on,
              title: 'Warehouse',
              subtitle: '2.4 km',
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 18,
            child: _MapBadge(
              icon: Icons.ev_station,
              title: 'Charging Station',
              subtitle: '5.1 km',
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(child: CustomPaint(painter: _RoutePainter())),
          ),
        ],
      ),
    );
  }
}

class _MapBadge extends StatelessWidget {
  const _MapBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 3),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF168A5B)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SOC history
// -----------------------------------------------------------------------------

class _SocHistoryCard extends StatelessWidget {
  const _SocHistoryCard({required this.values});

  final List<SOCHistoryEntity> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'SOC History',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: values.length < 2
                ? const _HistoryEmpty()
                : CustomPaint(
                    painter: _SocChartPainter(values),
                    child: const SizedBox.expand(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEmpty extends StatelessWidget {
  const _HistoryEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'SOC history will appear here',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Section title
// -----------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .end,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Text(
            trailing!,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Status chip
// -----------------------------------------------------------------------------

class VehicleStatusChip extends StatelessWidget {
  const VehicleStatusChip({super.key, required this.status});

  final FleetStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.foregroundColor),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: status.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Verdict logic
// -----------------------------------------------------------------------------

_SignalVerdict _normalVerdict(VehicleTelemetryEntity telemetry) {
  if (telemetry.lastPingAt == null) {
    return const _SignalVerdict(type: _SignalVerdictType.none, label: '');
  }

  if (telemetry.isStale) {
    return const _SignalVerdict(type: _SignalVerdictType.stale, label: 'STALE');
  }

  return const _SignalVerdict(type: _SignalVerdictType.normal, label: 'NORMAL');
}

_SignalVerdict _socVerdict(VehicleTelemetryEntity telemetry) {
  if (telemetry.soc == null) {
    return const _SignalVerdict(type: _SignalVerdictType.none, label: '');
  }

  if (telemetry.isStale) {
    return const _SignalVerdict(type: _SignalVerdictType.stale, label: 'STALE');
  }

  if (telemetry.soc! < 20) {
    return const _SignalVerdict(type: _SignalVerdictType.alert, label: 'ALERT');
  }

  return const _SignalVerdict(type: _SignalVerdictType.normal, label: 'NORMAL');
}

_SignalVerdict _temperatureVerdict(VehicleTelemetryEntity telemetry) {
  if (telemetry.batteryTemp == null) {
    return const _SignalVerdict(type: _SignalVerdictType.none, label: '');
  }

  if (telemetry.isStale) {
    return const _SignalVerdict(type: _SignalVerdictType.stale, label: 'STALE');
  }

  if (telemetry.batteryTemp! > 45) {
    return const _SignalVerdict(type: _SignalVerdictType.alert, label: 'ALERT');
  }

  return const _SignalVerdict(type: _SignalVerdictType.normal, label: 'NORMAL');
}

_SignalVerdict _pingVerdict(VehicleTelemetryEntity telemetry) {
  if (telemetry.lastPingAt == null) {
    return const _SignalVerdict(type: _SignalVerdictType.none, label: '');
  }

  if (telemetry.isStale) {
    return const _SignalVerdict(type: _SignalVerdictType.stale, label: 'STALE');
  }

  return const _SignalVerdict(type: _SignalVerdictType.normal, label: 'NORMAL');
}

// -----------------------------------------------------------------------------
// Formatting
// -----------------------------------------------------------------------------

String _formatPercent(double? value) {
  if (value == null) return '—';

  return '${value.toStringAsFixed(0)}%';
}

String _formatValue(double? value, {required String suffix}) {
  if (value == null) return '—';

  return '${value.toStringAsFixed(0)}$suffix';
}

String _formatAge(DateTime timestamp) {
  final difference = DateTime.now().difference(timestamp);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} sec ago';
  }

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  }

  if (difference.inHours < 24) {
    return '${difference.inHours} hr ago';
  }

  return '${difference.inDays} days ago';
}

// -----------------------------------------------------------------------------
// Placeholder map painter
// -----------------------------------------------------------------------------

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFAEBBA8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final majorRoadPaint = Paint()
      ..color = const Color(0xFFF4F0D8)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final road1 = Path()
      ..moveTo(0, size.height * .68)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .38,
        size.width,
        size.height * .56,
      );

    final road2 = Path()
      ..moveTo(size.width * .05, size.height * .15)
      ..quadraticBezierTo(
        size.width * .48,
        size.height * .68,
        size.width * .9,
        size.height * .15,
      );

    final majorRoad = Path()
      ..moveTo(0, size.height * .42)
      ..quadraticBezierTo(
        size.width * .45,
        size.height * .78,
        size.width,
        size.height * .3,
      );

    canvas.drawPath(road1, roadPaint);

    canvas.drawPath(road2, roadPaint);

    canvas.drawPath(majorRoad, majorRoadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = const Color(0xFF168AFF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * .18, size.height * .78)
      ..cubicTo(
        size.width * .28,
        size.height * .68,
        size.width * .32,
        size.height * .55,
        size.width * .48,
        size.height * .5,
      )
      ..cubicTo(
        size.width * .63,
        size.height * .45,
        size.width * .64,
        size.height * .27,
        size.width * .79,
        size.height * .2,
      );

    canvas.drawPath(path, routePaint);

    final start = Offset(size.width * .18, size.height * .78);

    final end = Offset(size.width * .79, size.height * .2);

    final markerPaint = Paint()
      ..color = const Color(0xFF168AFF)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(start, 6, markerPaint);

    canvas.drawCircle(end, 6, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// -----------------------------------------------------------------------------
// SOC chart painter
// -----------------------------------------------------------------------------

class _SocChartPainter extends CustomPainter {
  const _SocChartPainter(this.values);

  final List<SOCHistoryEntity> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final gridPaint = Paint()
      ..color = const Color(0xFFE8ECF0)
      ..strokeWidth = 1;

    final chartPaint = Paint()
      ..color = const Color(0xFF20A968)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0x3320A968)
      ..style = PaintingStyle.fill;

    const horizontalLines = 4;

    for (var i = 0; i <= horizontalLines; i++) {
      final y = size.height * i / horizontalLines;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Only records with a timestamp can be plotted on the time axis.
    final points = values.where((value) => value.time != null).toList();

    if (points.length < 2) return;

    points.sort((a, b) => a.time!.compareTo(b.time!));

    final minTime = points.first.time!.millisecondsSinceEpoch;
    final maxTime = points.last.time!.millisecondsSinceEpoch;
    final timeRange = maxTime - minTime;

    final path = Path();

    for (var i = 0; i < points.length; i++) {
      final point = points[i];

      final x = timeRange == 0
          ? size.width * i / (points.length - 1)
          : ((point.time!.millisecondsSinceEpoch - minTime) / timeRange) *
                size.width;

      final soc = point.soc.clamp(0.0, 100.0);

      final y = size.height - ((soc / 100.0) * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, chartPaint);
  }

  @override
  bool shouldRepaint(covariant _SocChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
