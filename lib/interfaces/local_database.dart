abstract class LocalDatabase {
  Future<void> init({bool inMemory = false});
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs});
  Future<dynamic> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs});
  Future<dynamic> insert(String table, Map<String, Object?> values);
  Future<List<Map<String, Object?>>> query(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset});
  Future<int> rawDelete(String sql, [List<Object?>? arguments]);
  Future<dynamic> rawInsert(String sql, [List<Object?>? arguments]);
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]);
  Future<dynamic> rawUpdate(String sql, [List<Object?>? arguments]);
  Future<bool> isSaved(String table, {required dynamic id});
}
