abstract final class AppStartup {
  AppStartup._();

  static DateTime? _start;

  static void mark() => _start ??= DateTime.now();

  static bool get isMarked => _start != null;

  static int? get elapsedMs {
    final start = _start;
    if (start == null) return null;
    return DateTime.now().difference(start).inMilliseconds;
  }
}