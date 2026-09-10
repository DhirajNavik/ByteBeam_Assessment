String deriveVehicleStatus({
  required int? ignition,
  required double? speed,
  required DateTime? lastSeen,
}) {
  final isStale =
      lastSeen == null || DateTime.now().difference(lastSeen).inMinutes > 10;

  if ((ignition ?? 0) == 0 || isStale) return 'OFFLINE';
  if (speed != null && speed > 0.1) return 'MOVING';
  return 'STOPPED';
}