class DatabaseException implements Exception {
  final Object? error;
  final StackTrace? stackTrace;

  const DatabaseException(
    this.error,
    this.stackTrace,
  );

  @override
  String toString() {
    return error.toString();
  }
}