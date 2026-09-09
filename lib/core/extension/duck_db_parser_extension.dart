extension DuckDBParserExtension on List<List<Object?>> {
  List<T> parseList<T>(
    T Function(Map<String, dynamic> json) fromJson,
    List<String> columns,
  ) {
    return map((row) {
      final json = <String, dynamic>{};
      for (int i = 0; i < columns.length && i < row.length; i++) {
        json[columns[i]] = row[i];
      }
      return fromJson(json);
    }).toList();
  }
}

extension DuckDBObjectExtension on List<Object?> {
  T parseObject<T>(
    T Function(Map<String, dynamic> json) fromJson,
    List<String> columns,
  ) {
    final json = <String, dynamic>{};
    for (int i = 0; i < columns.length && i < length; i++) {
      json[columns[i]] = this[i];
    }
    return fromJson(json);
  }
}
