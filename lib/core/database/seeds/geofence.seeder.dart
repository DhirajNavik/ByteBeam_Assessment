import 'package:bytebeam_assessment/core/database/utils/db_path.dart';
import 'package:bytebeam_assessment/core/database/tables/geofence.table.dart';
import 'package:dart_duckdb/dart_duckdb.dart';

abstract final class GeofenceSeeder {
  GeofenceSeeder._();

  static const List<_GeofenceSeed> _seeds = [
    _GeofenceSeed(
      id: 1,
      name: 'North Bengaluru Hub',
      latitude: 12.92,
      longitude: 77.63,
      radiusMeters: 8000,
    ),
    _GeofenceSeed(
      id: 2,
      name: 'Central Depot',
      latitude: 12.97,
      longitude: 77.59,
      radiusMeters: 8000,
    ),
    _GeofenceSeed(
      id: 3,
      name: 'East Corridor',
      latitude: 12.95,
      longitude: 77.75,
      radiusMeters: 8000,
    ),
    _GeofenceSeed(
      id: 4,
      name: 'Decommissioned Yard',
      latitude: 13.00,
      longitude: 77.58,
      radiusMeters: 5000,
      isActive: false,
    ),
  ];

  static Future<void> seed(Connection connection) async {
    final result = await connection.query(
      'SELECT COUNT(*) FROM ${DBPath.geofencesTable}',
    );
    final count = (result.fetchAll().first.first as num).toInt();
    await result.dispose();

    if (count > 0) return;

    final now = DateTime.now().toIso8601String();

    for (final seed in _seeds) {
      await connection.query('''
        INSERT INTO ${DBPath.geofencesTable} (
          ${GeofenceTable.id},
          ${GeofenceTable.name},
          ${GeofenceTable.latitude},
          ${GeofenceTable.longitude},
          ${GeofenceTable.radiusMeters},
          ${GeofenceTable.isActive},
          ${GeofenceTable.createdAt},
          ${GeofenceTable.updatedAt}
        ) VALUES (
          ${seed.id},
          '${seed.name}',
          ${seed.latitude},
          ${seed.longitude},
          ${seed.radiusMeters},
          ${seed.isActive},
          TIMESTAMP '$now',
          TIMESTAMP '$now'
        )
      ''');
    }
  }
}

class _GeofenceSeed {
  const _GeofenceSeed({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.isActive = true,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;
}