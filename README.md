# Fleet Console — Local-First Fleet Intelligence Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Database](https://img.shields.io/badge/DuckDB-Embedded_OLAP-FFF000?style=for-the-badge&logo=duckdb&logoColor=black)](https://duckdb.org)
[![Tests](https://img.shields.io/badge/Unit_Tests-42%2F42_Passed-success?style=for-the-badge&logo=checkmarx&logoColor=white)](https://github.com)
[![Analysis](https://img.shields.io/badge/Static_Analysis-0_Issues-success?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

> **Bytebeam Take-Home Assessment — SDE-3 (Flutter)**  
> An offline-capable, high-throughput fleet telemetry console engineered for 500 electric commercial vehicles emitting noisy, out-of-order sensor packets over intermittent cellular connections.

---

## Table of Contents
1. [System Context & Objectives](#1-system-context--objectives)
2. [Architectural Blueprint](#2-architectural-blueprint)
3. [Resolving Data Ambiguities](#3-resolving-data-ambiguities-the-hard-problems)
4. [Scale Exercise & Storage Math (500 Vehicles, 30 Days)](#4-scale-exercise--storage-math)
5. [Feature Tour](#5-feature-tour)
6. [Prerequisites & Build Instructions](#6-prerequisites--build-instructions)
7. [Comprehensive Test Suite & Verification](#7-comprehensive-test-suite--verification)
8. [Architectural Decision Records (ADRs)](#8-architectural-decision-records-adrs)
9. [Project Directory Layout](#9-project-directory-layout)

---

## 1. System Context & Objectives

A fleet operator overseeing 500 electric trucks needs a unified desktop/tablet console answering three fundamental operational questions at a glance:
- **Where are my vehicles?** (Spatial distribution, geofence presence, active origins & destinations).
- **Are they okay?** (Battery State of Charge, cell temperatures, telemetry freshness, connectivity).
- **What needs attention right now?** (Critical/Warning alerts, stale uncommunicative trucks, rapid charge loss).

### Real-World Realities & Constraints
- **Unreliable Network Transport**: Sensor packets arrive out-of-order, duplicated, late, or in bursts (e.g., when a vehicle exits an underground concrete depot after 6 hours).
- **No Heavy Server Dependency**: The client application must function reliably with a **local-first** paradigm, capable of performing complex aggregations and spatial queries directly on the local machine using an embedded columnar analytical engine.
- **Microsecond Responsiveness**: The UI must maintain 60/120 FPS rendering across 500 vehicles without UI thread jank caused by analytical queries or ingestion batches.

---

## 2. Architectural Blueprint

The application is structured following Clean Architecture with strict boundary separation between **Domain**, **Data**, and **Presentation** layers:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             PRESENTATION LAYER                              │
│                                                                             │
│  [Fleet Dashboard]      [Vehicle Detail View]      [Alerts Management Drawer]│
│         │                         │                            │            │
│  [VehicleBloc]          [VehicleDetailsBloc]              [AlertsBloc]      │
│  [TelemetryBloc]        [ThemeCubit]                      [GeofenceBloc]    │
└──────────────────────────────────────▲──────────────────────────────────────┘
                                       │ State & Events
┌──────────────────────────────────────┴──────────────────────────────────────┐
│                                DOMAIN LAYER                                 │
│                                                                             │
│       Pure Reconcilers (Zero Side-Effects, 100% Deterministic & Pure)        │
│    ┌──────────────────────┬──────────────────────┬──────────────────────┐   │
│    │   AlertReconciler    │  GeofenceReconciler  │    TripReconciler    │   │
│    │  (State Transition)  │   (Haversine+Jitter) │ (Sequence Id Aware)  │   │
│    └──────────────────────┴──────────────────────┴──────────────────────┘   │
│                                      ▲                                      │
│                  Use Cases (WatchTelemetry, DismissAlert, etc.)              │
└──────────────────────────────────────▲──────────────────────────────────────┘
                                       │ Repository Abstractions
┌──────────────────────────────────────┴──────────────────────────────────────┐
│                             DATA & ENGINE LAYER                             │
│                                                                             │
│  DuckDB Native Database (`dart_duckdb`) — In-Process OLAP Columnar Store     │
│  ┌──────────────────────┬──────────────────────┬──────────────────────┐     │
│  │   telemetry (raw)    │  telemetry_hourly    │     vehicles         │     │
│  ├──────────────────────┼──────────────────────┼──────────────────────┤     │
│  │   geofences          │  geofence_events     │     trips & alerts   │     │
│  └──────────────────────┴──────────────────────┴──────────────────────┘     │
│                                      ▲                                      │
│  DataSources (SQL Executions, Seeder Benchmark Service, Event Streamers)    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Why Embedded DuckDB?
Traditional mobile/desktop databases (SQLite, Hive, Isar) are row-oriented and struggle with heavy analytical time-series rollups across millions of rows. DuckDB provides:
- **Vectorized Columnar Execution**: Scans, filters, and computes mathematical rollups (`AVG`, `MIN`, `MAX`, `date_trunc`) over millions of records in tens of milliseconds.
- **Rich SQL Dialect**: Direct analytical SQL capabilities (window functions, time buckets, aggregations) executed locally in-process without network overhead.
- **In-Memory & Persistent Modes**: High throughput batched writes without locking UI reads.

---

## 3. Resolving Data Ambiguities (The Hard Problems)

The core challenge of this assessment is not the sheer volume of UI widgets, but how edge cases and data ambiguities are handled:

### 1. Packet Reordering & Basement Backlogs
- **The Problem**: A vehicle parks in a basement for hours with zero mobile signal. Upon driving out, it flushes 5,000 queued telemetry packets in a single burst. Packets may arrive out-of-order or with timestamps that differ from the receipt order.
- **Solution**: 
  - Every telemetry packet carries an incremental `sequenceId` emitted by the vehicle's onboard telematics unit.
  - The reconcilers sort unconsumed packets by `sequenceId` (event sequence) rather than network ingestion time before evaluating transitions.
  - All temporal calculations use `timestamp` (event-time on the vehicle) rather than local wall-clock ingestion time.

### 2. Staleness vs. Recovery (The Silence Fallacy)
- **The Problem**: If a vehicle with a Critical SOC alert (e.g., 6%) goes through a tunnel or loses signal, the reconciler receives no new data or a ping with `lastSeen > 15 minutes` ago. A naive rule engine might consider the alert "resolved" because there is no failing reading in the current window.
- **Solution**:
  - `AlertReading.isStale(now)` evaluates to `true` if `lastSeen == null` or `now.difference(lastSeen) > 15 minutes`.
  - In `AlertReconciler`, **staleness freezes evaluation**: no new alerts are opened, no alerts are escalated or de-escalated, and critically, **no existing alerts are resolved**. Silence is treated as unknown state, never as recovery.

### 3. Geofence Boundary Jitter & GPS Flapping
- **The Problem**: GPS multi-path error can cause a stationary vehicle parked near a geofence perimeter to report coordinates oscillating inside and outside the boundary by 5–15 meters every second, causing thousands of spurious entry/exit events.
- **Solution**:
  - `GeofenceReconciler` implements radial hysteresis. When evaluating an exit from a geofence, the vehicle's distance from the center must exceed `radius + toleranceMeters` (jitter suppression threshold). If within the jitter margin, the crossing is suppressed.

### 4. Alert Lifecycle & Reactivation on Escalation
- **The Problem**: An operator dismisses an annoying Warning alert (`SOC < 20%`). Later, the vehicle's battery drains further into Critical (`SOC < 10%`).
- **Solution**:
  - Dismissed alerts track their dismissed state.
  - If the condition remains Warning or recovers, it stays dismissed.
  - If the severity worsens (`warning -> critical`), the reconciler automatically issues a `ReactivateAlert` mutation, forcing it back to active state on the operator's screen.
  - If the battery is recharged and returns to normal (`SOC > 20%`), the alert is cleanly resolved regardless of whether it was active or dismissed.

### 5. Single Active Trip Invariant
- **The Problem**: Duplicated exit packets, GPS glitches, or missing entry events can lead to overlapping or corrupted trip records.
- **Solution**:
  - A vehicle can have strictly **at most one active trip** at any point in time.
  - An exit event when a trip is already open is discarded.
  - An entry event when no trip is active (orphan entry) is safely discarded.

---

## 4. Scale Exercise & Storage Math

### Theoretical Volume: 500 Vehicles over 30 Days
| Parameter | Value | Notes |
| :--- | :--- | :--- |
| **Fleet Size** | 500 electric trucks | Standard commercial fleet |
| **Emit Frequency** | 1 ping / second / truck | High-resolution telemetry |
| **Pings / Min / Fleet** | $500 \times 60 = 30,000$ | Ingestion stream |
| **Pings / Day / Fleet** | $500 \times 86,400 = 43,200,000$ | 43.2 Million pings / day |
| **30-Day Fleet Total** | $43.2\text{M} \times 30 = \mathbf{1,296,000,000}$ | **~1.30 Billion telemetry points** |

---

### Storage Analysis: Raw vs. Compressed vs. Rollup

If stored as naive JSON or uncompressed rows:
$$\approx 120\text{ bytes/row} \times 1.296\text{B rows} \approx \mathbf{155.5\text{ GB (Impractical on client devices)}}$$

#### The Two-Tier Storage Architecture:
1. **Tier 1 — Hot Raw Window (Last 24–48 Hours)**:
   - Stores raw second-by-second telemetry in the `telemetry` table.
   - DuckDB applies automatic Bitpacking, Dictionary Encoding, and Frame-of-Reference (FoR) compression on timestamps and floats, achieving ~12 bytes/row:
     $$43,200,000\text{ rows/day} \times 12\text{ bytes} \approx \mathbf{518\text{ MB/day}}$$
   - Retaining a 48-hour rolling window requires only $\approx 1.0\text{ GB}$ of disk space.

2. **Tier 2 — Cold Hourly Aggregation Table (`telemetry_hourly`)**:
   - Every hour, a background transactional aggregation task rolls up the 3,600 raw seconds per vehicle into a single summary record:
     ```sql
     INSERT INTO telemetry_hourly
     SELECT 
       vehicle_id,
       date_trunc('hour', timestamp) AS bucket_hour,
       AVG(soc) AS avg_soc,
       MIN(soc) AS min_soc,
       MAX(soc) AS max_soc,
       AVG(battery_temp) AS avg_temp,
       MAX(battery_temp) AS max_temp,
       MAX(odometer) - MIN(odometer) AS distance_km,
       COUNT(*) AS packet_count
     FROM telemetry
     WHERE timestamp >= ? AND timestamp < ?
     GROUP BY vehicle_id, bucket_hour;
     ```
   - **30-Day Rollup Volume**:
     $$500\text{ vehicles} \times 24\text{ hours} \times 30\text{ days} = \mathbf{360,000\text{ rows}}$$
   - Total 30-day storage for hourly rollups: **$\approx 18\text{ MB}$**.

3. **Pruning Routine**:
   - Periodically executes: `DELETE FROM telemetry WHERE timestamp < NOW() - INTERVAL '48 HOURS';`
   - Keeps client storage bounded, performant, and reliable over months of operation.

---

## 5. Feature Tour

### Feature A: Live Fleet Dashboard
- Real-time fleet cards with instant categorization:
  - ⚡ **Charging**: Positive current flow, increasing battery SOC.
  - 🚛 **Driving**: Speed $> 0\text{ km/h}$, discharge current.
  - 🅿️ **Idling**: Speed $= 0\text{ km/h}$, ignition ON.
  - 💤 **Inactive/Offline**: No signal for $> 15\text{ mins}$ or ignition OFF.
- Quick search by registration ID, VIN, or make/model.
- Status filters (All, Charging, Driving, Idling, Inactive) and Alert filters (Critical, Warning).

### Feature B: Vehicle Detail & History
- Comprehensive single-vehicle overview with real-time KPI chips (Odometer, Current Speed, Battery Temp, Remaining Range).
- Interactive Battery SOC time-series chart driven by hourly rollups.
- Geofence presence indicators and recent crossing history.
- Real-time telemetry inspector stream.

### Feature C: Rule-Based Alert System
- **Thresholds**:
  - `battery_soc < 10%`: **Critical**
  - `battery_soc < 20%`: **Warning**
  - `battery_temp > 45°C`: **Overheat Warning/Critical**
- Dismiss with Undo action.
- Automatic severity escalation (`warning -> critical`) with alert reactivation.
- Automatic resolution once readings return to healthy bands.

### Feature D: Geofence Engine & Automated Trips
- Point-in-circular-geofence detection using high-performance Haversine math.
- Automatic trip lifecycle:
  - Departure from depot (`exit`) $\rightarrow$ generates `StartTrip`.
  - Arrival at destination warehouse (`entry`) $\rightarrow$ generates `CompleteTrip`.
  - Hysteresis buffering suppresses boundary false alarms.

### Feature E: Scale Benchmark & Synthetic Generator
- Built-in `ScaleBenchmarkService` capable of seeding **2,000,000 synthetic telemetry records** to benchmark insertion throughput and verify sub-100ms analytical query latency directly on the target machine.

---

## 6. Prerequisites & Build Instructions

### Prerequisites
- **Flutter SDK**: `>= 3.24.0`
- **Dart SDK**: `>= 3.5.0`
- **Platform Toolchains**:
  - **Windows**: Visual Studio 2022 with *Desktop development with C++* workload (required for DuckDB C++ bindings).
  - **macOS**: Xcode with Command Line Tools.
  - **Linux**: `clang`, `cmake`, `ninja-build`, `pkg-config`.

---

### Step-by-Step Setup

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd bytebeam_assessment
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Code Generation (Injectable & Freezed)**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Verify Static Analysis**:
   ```bash
   flutter analyze
   ```
   *Should report: `No issues found!`*

5. **Run the Application**:
   ```bash
   # Windows Desktop (Recommended)
   flutter run -d windows

   # macOS Desktop
   flutter run -d macos

   # Web / Chrome
   flutter run -d chrome
   ```

---

## 7. Comprehensive Test Suite & Verification

The project includes **42 automated unit tests** covering all reconcilers, mathematical calculations, and edge cases.

### Run All Tests
```bash
flutter test
```

### Run Tests with Detailed Verbose Output
```bash
flutter test --reporter expanded
```

---

### Test Suite Breakdown

#### 1. `AlertReconciler` (`test/app/alert_reconciler_test.dart` — 19 Tests)
- **New Alert Detection**:
  - SOC below warning threshold ($18\%$) opens a warning alert.
  - SOC below critical threshold ($5\%$) opens critical directly, skipping warning.
  - Battery temperature $> 50^\circ\text{C}$ opens overheat alert independently of SOC.
  - Healthy readings produce zero mutations.
  - Duplicate prevention: does not reopen an already active alert for the same vehicle and type.
- **Escalation & De-escalation**:
  - Active warning escalates to critical when SOC drops further.
  - Active critical de-escalates to warning when SOC partially recovers.
- **Dismissal & Reactivation**:
  - Dismissed warning escalates and reactivates as critical when conditions worsen.
  - De-escalation or unchanged severity while dismissed leaves the alert dismissed without mutation.
- **Resolution**:
  - Metric returning to normal range resolves active alert.
  - Metric returning to normal resolves a dismissed alert.
  - Resolved alert re-triggering opens a brand-new alert, not a revival.
- **Staleness Handling**:
  - Stale reading ($> 15\text{ mins}$) with no open alert does not open an alert even if SOC is critical.
  - Stale reading does not resolve an existing alert (loss of signal $\neq$ battery recovery).
  - Explicit `null` `lastSeen` correctly counts as stale.
  - Exact staleness boundary testing ($> 15\text{ mins}$ vs $\ge 15\text{ mins}$).
- **Independence**:
  - Multiple vehicles evaluated independently.
  - SOC alerts and Overheat alerts on the same vehicle tracked separately.

#### 2. `GeofenceReconciler` (`test/app/geofence_reconciler_test.dart` — 15 Tests)
- **Transitions**:
  - Entry recorded when vehicle first appears inside geofence boundary.
  - No mutation when vehicle first appears outside geofence.
  - Exit recorded when vehicle transitions from inside to outside.
  - Re-entry recorded upon entering again after an exit.
- **Jitter & Noise Suppression**:
  - Suppresses false exit when vehicle position is within jitter tolerance margin.
  - Ignores out-of-order stale packet with lower sequence ID.
  - No duplicate entries when remaining inside.
  - No duplicate exits when remaining outside.
- **Haversine Math & Geometry**:
  - `containsPoint` returns true for exact center and inside points.
  - `containsPoint` returns false for points outside perimeter.
  - Handles multiple vehicles and geofences simultaneously.

#### 3. `TripReconciler` (`test/app/trip_reconciler_test.dart` — 8 Tests)
- **Trip Lifecycle**:
  - Returns empty mutations for empty crossing lists.
  - Exit event starts trip with origin geofence ID and timestamp.
  - Entry event completes active trip with destination geofence ID and timestamp.
  - Complete exit $\rightarrow$ entry cycle processed correctly in single batch.
- **Invariants & Resilience**:
  - Ignores duplicate exit when active trip already exists.
  - Ignores orphan entry when no active trip exists.
  - Automatically sorts out-of-order unconsumed crossing packets by `sequenceId`.
  - Independent lifecycle management across multiple concurrent vehicles.

---

## 8. Architectural Decision Records (ADRs)

### ADR 1: Pure Reconcilers vs. ORM Lifecycle Hooks
- **Decision**: All business rules (alerts, geofence crossings, trip states) are implemented as pure, static Dart functions that accept input arrays and return immutable mutation objects.
- **Rationale**: Direct DB mutation inside domain rules creates hidden side effects, concurrency deadlocks, and untestable code. Pure reconcilers can be executed concurrently in background Dart isolates, tested with zero mocks, and applied inside single atomic DB transactions.

### ADR 2: In-Process DuckDB vs. SQLite / Hive
- **Decision**: Use `dart_duckdb` for client-side storage and telemetry analytics.
- **Rationale**: SQLite is row-oriented; scanning 2,000,000 rows to calculate hourly rollups or percentiles locks the database for multiple seconds. DuckDB’s vectorized columnar engine computes analytical rollups across millions of rows in $< 50\text{ms}$.

### ADR 3: Event-Time Sequence Sorting vs. Arrival-Time
- **Decision**: All trip and geofence state engines sort unconsumed packets by `sequenceId` and `timestamp`.
- **Rationale**: Cellular jitter and multi-path routing mean packets frequently arrive at the client out of order. Relying on arrival time corrupts trip detection (e.g., an entry arriving before an exit).

---

## 9. Project Directory Layout

```
lib/
├── config/
│   ├── injectors/               # GetIt dependency injection & Injectable module
│   │   ├── injectable.dart
│   │   └── injectable.config.dart
│   └── routes/                  # Declarative GoRouter routing definitions
├── core/
│   ├── database/                # DuckDB schema, connection pool & migrations
│   │   ├── database_module.dart
│   │   └── utils/               # Pure Reconcilers
│   │       ├── alert_reconciler.dart
│   │       ├── alert_thresholds.dart
│   │       ├── geofence_reconciler.dart
│   │       └── trip_reconciler.dart
│   ├── extension/               # Context & responsive helper extensions
│   ├── themes/                  # Light & Dark theme tokens
│   ├── usecase/                 # Clean Architecture base UseCase & Failure classes
│   └── utils/                   # Dimensions, assets, and widget helpers
└── feature/
    ├── alerts/                  # Alert management drawer, BLoC, entities & use cases
    ├── geofence/                # Geofence boundary rendering, badges & BLoC
    ├── telemetry/               # Fleet dashboard, vehicle details, scale seeder & BLoC
    ├── theme/                   # Theme switching Cubit (Light/Dark/System)
    └── trips/                   # Trip cards and crossing history
```

---

## Summary Checklist for Reviewers

| Requirement | Status | Evidence |
| :--- | :---: | :--- |
| **Fleet Overview (500 trucks)** | ✅ | Grid/List views, operational statuses, filters, search |
| **Vehicle Detail Screen** | ✅ | Hourly aggregated SOC history, geofence log, live stream |
| **Local-First with DuckDB** | ✅ | Native `dart_duckdb` embedded analytical engine |
| **Alert Reconciliation** | ✅ | Pure state machine, warning/critical, freeze on stale |
| **Trip Detection Engine** | ✅ | Automatic exit/entry detection, sequence-ordered |
| **Scale Math & Retention** | ✅ | 1.3B ping math, 2-tier rolling window, 2M row seeder |
| **Code Cleanliness** | ✅ | `flutter analyze` $\rightarrow$ 0 warnings / 0 lints |
| **Automated Unit Tests** | ✅ | **42 / 42 tests passing** |
