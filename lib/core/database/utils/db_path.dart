class DBPath {
  DBPath._();

  static const String databaseName = 'fleet_console.duckdb';

  static const String vehiclesTable = "vehicles";
  static const String telemetryTable = 'telemetry';
  static const String alertsTable = 'alerts';
  static const String geofencesTable = 'geofences';
  static const String geofenceEventsTable = 'geofenceEvents';
  static const String tripsTable = 'trips';
  static const String telemetryHourlyTable = 'telemetryHourly';
}
