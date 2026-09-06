import 'package:dart_duckdb/dart_duckdb.dart';

import 'exception.dart';

class DatabaseExceptionHandler {
  DatabaseExceptionHandler._();

  static DatabaseException handle(Object error, StackTrace stackTrace) {
    if (error is DuckDBCancelledException) {
      return DatabaseException('Database operation cancelled.', stackTrace);
    }

    if (error is DuckDBException) {
      return DatabaseException(error, stackTrace);
    }

    return DatabaseException(error, stackTrace);
  }
}
