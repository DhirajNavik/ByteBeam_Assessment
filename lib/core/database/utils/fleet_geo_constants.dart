abstract final class FleetGeoConstants {
  FleetGeoConstants._();

  static const double minLat = 12.85;
  static const double maxLat = 12.85 + 0.25;

  static const double minLon = 77.45;
  static const double maxLon = 77.45 + 0.35;

  static const double centerLat = (minLat + maxLat) / 2;
  static const double centerLon = (minLon + maxLon) / 2;

  static double randomLat(double random) => minLat + random * (maxLat - minLat);
  static double randomLon(double random) => minLon + random * (maxLon - minLon);
}