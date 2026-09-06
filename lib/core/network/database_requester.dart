import 'package:dart_duckdb/dart_duckdb.dart';
import 'package:injectable/injectable.dart';

import 'handler.dart';

@singleton
class DatabaseRequester {
  final Connection _connection;

  const DatabaseRequester(this._connection);

  Future<List<List<Object?>>> query(String sql) async {
    try {
      final response = await _connection.query(sql);

      try {
        return response.fetchAll();
      } finally {
        await response.dispose();
      }
    } catch (error, stackTrace) {
      throw DatabaseExceptionHandler.handle(error, stackTrace);
    }
  }
}
