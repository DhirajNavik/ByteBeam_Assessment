/// Mutable, in-memory state for one vehicle across simulation ticks.
///
/// Fields are split into three groups:
///   • Static profile  — loaded once from the DB, never changed.
///   • Live telemetry  — the values written to the DB on every tick.
///   • Sim internals   — scratch fields used only by [SimulationConfig] /
///                       [TelemetrySnapshot]; never persisted.
final class SimulationState {
  SimulationState({
    // ── Static profile ──────────────────────────────────────────────────────
    required this.vehicleId,
    required this.maxSpeed,
    required this.totalRange,
    this.batteryCapacityKwh = 30.0,
    this.minOperatingTemp = 20.0,
    this.maxOperatingTemp = 50.0,
    this.tickIntervalSeconds = 2,
    this.startLatitude = 12.9716,
    this.startLongitude = 77.5946,
    this.destinationLatitude = 12.9352,
    this.destinationLongitude = 77.6245,
    this.driveCycleLengthFactor = 1.0,
    this.stopCycleLengthFactor = 1.0,
    // ── Live telemetry ───────────────────────────────────────────────────────
    required this.soc,
    this.speed = 0.0,
    this.batteryTemperature = 29.0,
    this.rangeKm = 0.0,
    this.odometer = 0.0,
    this.ignition = 1,
    this.latitude = 12.9716,
    this.longitude = 77.5946,
    required this.lastSeen,
    // ── Sim internals ────────────────────────────────────────────────────────
    this.driving = false,
    this.targetSpeed = 0.0,
    this.drivingTicks = 0,
    this.stoppedTicks = 0,
    this.generated = false,
    this.charging = false,
  });

  // ── Static profile ─────────────────────────────────────────────────────────
  // Loaded from the vehicles table once; never mutated during simulation.

  /// Primary key — matches vehicles.id in the DB.
  final int vehicleId;

  /// Maximum speed in km/h — caps all speed targets in [SimulationConfig].
  final double maxSpeed;

  /// Rated full-charge range in km — baseline for range estimation.
  final double totalRange;

  /// Battery capacity in kWh — scales SOC drain rates.
  /// Defaults to 30 kWh if not provided by the vehicles table.
  final double batteryCapacityKwh;

  /// Lower bound of the battery's safe operating temperature in °C.
  final double minOperatingTemp;

  /// Upper bound — vehicle shuts down when [batteryTemperature] reaches this.
  final double maxOperatingTemp;

  /// Wall-clock seconds between simulation ticks — used for odometer math.
  final int tickIntervalSeconds;

  /// Route start — used to compute lat/lon movement direction per tick.
  final double startLatitude;
  final double startLongitude;

  /// Route destination — vehicle interpolates toward this position.
  final double destinationLatitude;
  final double destinationLongitude;

  /// Scales how many ticks the vehicle stays in "driving" mode.
  /// 1.0 = default (20 ticks); 0.5 = shorter trips; 2.0 = longer trips.
  final double driveCycleLengthFactor;

  /// Scales how many ticks the vehicle waits before resuming after a stop.
  /// 1.0 = default (8 ticks).
  final double stopCycleLengthFactor;

  // ── Live telemetry ──────────────────────────────────────────────────────────
  // Written to the DB on every generated tick.

  /// State of charge as a percentage [0, 100].
  double soc;

  /// Current speed in km/h.
  double speed;

  /// Battery pack temperature in °C.
  double batteryTemperature;

  /// Estimated remaining range in km.
  double rangeKm;

  /// Total distance travelled in km (cumulative).
  double odometer;

  /// Ignition state: 1 = on, 0 = off.
  int ignition;

  /// Current GPS latitude.
  double latitude;

  /// Current GPS longitude.
  double longitude;

  /// Timestamp of the last generated record.
  DateTime lastSeen;

  // ── Sim internals ───────────────────────────────────────────────────────────
  // Used exclusively by [SimulationConfig] and [TelemetrySnapshot].
  // Never written to the DB.

  /// Whether the vehicle is currently in a "driving" phase of its cycle.
  bool driving;

  /// Speed the vehicle is currently trying to reach.
  double targetSpeed;

  /// Ticks elapsed since the current driving phase started.
  int drivingTicks;

  /// Ticks elapsed since the vehicle last stopped.
  int stoppedTicks;

  /// Set to true by [TelemetrySnapshot] when this tick produced a DB row.
  bool generated;
  bool charging;
  // ── copyWith ────────────────────────────────────────────────────────────────

  /// Returns a full copy of this state.
  ///
  /// [TelemetrySnapshot.fromLastState] uses this to work on a throw-away
  /// copy so the original is not mutated until the tick is committed.
  SimulationState copyWith() => SimulationState(
    // static profile
    vehicleId: vehicleId,
    maxSpeed: maxSpeed,
    totalRange: totalRange,
    batteryCapacityKwh: batteryCapacityKwh,
    minOperatingTemp: minOperatingTemp,
    maxOperatingTemp: maxOperatingTemp,
    tickIntervalSeconds: tickIntervalSeconds,
    startLatitude: startLatitude,
    startLongitude: startLongitude,
    destinationLatitude: destinationLatitude,
    destinationLongitude: destinationLongitude,
    driveCycleLengthFactor: driveCycleLengthFactor,
    stopCycleLengthFactor: stopCycleLengthFactor,
    // live telemetry
    soc: soc,
    speed: speed,
    batteryTemperature: batteryTemperature,
    rangeKm: rangeKm,
    odometer: odometer,
    ignition: ignition,
    latitude: latitude,
    longitude: longitude,
    lastSeen: lastSeen,
    // sim internals
    driving: driving,
    targetSpeed: targetSpeed,
    drivingTicks: drivingTicks,
    stoppedTicks: stoppedTicks,
    generated: generated,
    charging: charging,
  );

  @override
  String toString() =>
      'SimulationState('
      'vehicleId: $vehicleId, '
      'ignition: $ignition, '
      'soc: ${soc.toStringAsFixed(2)}, '
      'speed: ${speed.toStringAsFixed(1)}, '
      'temp: ${batteryTemperature.toStringAsFixed(1)}, '
      'range: ${rangeKm.toStringAsFixed(1)}, '
      'odometer: ${odometer.toStringAsFixed(2)}, '
      'driving: $driving, '
      'charging: $charging, '
      'generated: $generated'
      ')';
}
