import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/core/constants/sql_scripts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase implements LocalDatabase {
  late Database _database;
  @override
  Future<void> init({bool inMemory = false}) async {
    try {
      _database = await openDatabase(
        inMemory ? inMemoryDatabasePath : join(await getDatabasesPath(), 'data.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute(SQLScripts.createTablePreferences);
          await db.execute(SQLScripts.createTablePerson);
          await db.execute(SQLScripts.createTableCompressor);
          await db.execute(SQLScripts.createTableCoalescent);
          await db.execute(SQLScripts.createTableEvaluation);
          await db.execute(SQLScripts.createTableEvaluationTechnician);
          await db.execute(SQLScripts.createTableEvaluationCoalescent);
          await db.execute(SQLScripts.createTableEvaluationPhoto);
          await db.execute(SQLScripts.createTableSchedule);
          await db.execute(SQLScripts.insertThemePreference);
          await db.execute(SQLScripts.insertLastSyncPreference);
          await db.execute(SQLScripts.insertSyncronizingPreference);
          await db.execute(SQLScripts.insertloggedTechnicianIdPreference);
        },
      );
    } on DatabaseException catch (e) {
      throw LocalDatabaseException('LDB001', 'Falha ao inicializar o banco de dados: $e');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    try {
      int deletedRows = await _database.delete(table, where: where, whereArgs: whereArgs);
      return deletedRows;
    } catch (e) {
      throw LocalDatabaseException('LDB002', 'Erro ao excluir: $e');
    }
  }

  @override
  Future<dynamic> insert(String table, Map<String, Object?> values) async {
    try {
      dynamic lastInsertedId = await _database.insert(table, values);
      return lastInsertedId;
    } catch (e) {
      throw LocalDatabaseException('LDB003', 'Erro ao salvar: $e');
    }
  }

  @override
  Future<dynamic> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs}) async {
    try {
      int changes = await _database.update(table, values, where: where, whereArgs: whereArgs);
      return changes;
    } catch (e) {
      throw LocalDatabaseException('LDB004', 'Erro ao atualizar: $e');
    }
  }

  @override
  Future<List<Map<String, Object?>>> query(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset}) async {
    try {
      List<Map<String, Object?>> result = await _database.query(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset);
      return _resultSetToRawResult(result);
    } catch (e) {
      throw LocalDatabaseException('LDB005', 'Erro ao consultar: $e');
    }
  }

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    try {
      int deletedRows = await _database.rawDelete(sql, arguments);
      return deletedRows;
    } catch (e) {
      throw LocalDatabaseException('LDB006', 'Erro ao deletar: $e');
    }
  }

  @override
  Future<dynamic> rawInsert(String sql, [List<Object?>? arguments]) async {
    try {
      int lastinsertedidd = await _database.rawInsert(sql, arguments);
      return lastinsertedidd;
    } catch (e) {
      throw LocalDatabaseException('LDB007', 'Erro ao salvar: $e');
    }
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    try {
      List<Map<String, Object?>> result = await _database.rawQuery(sql, arguments);
      return _resultSetToRawResult(result);
    } catch (e) {
      throw LocalDatabaseException('LDB008', 'Erro ao consultar: $e');
    }
  }

  @override
  Future<dynamic> rawUpdate(String sql, [List<Object?>? arguments]) async {
    try {
      int changes = await _database.rawUpdate(sql, arguments);
      return changes;
    } catch (e) {
      throw LocalDatabaseException('LDB009', 'Erro ao atualizar: $e');
    }
  }

  @override
  Future<bool> isSaved(String table, {required dynamic id}) async {
    try {
      final data = await _database.query(table, where: 'id = ?', whereArgs: [id]);
      if (data.isEmpty) return false;
      return true;
    } catch (e) {
      throw LocalDatabaseException('LDB010', 'Erro ao verificar a existencia do registro: $e');
    }
  }

  List<Map<String, Object?>> _resultSetToRawResult(List<Map<String, Object?>> resultset) {
    List<Map<String, Object?>> list = [];
    Map<String, Object?> map = {};
    for (var row in resultset) {
      for (var key in row.keys) {
        map[key] = row[key];
      }
      list.add(map);
      map = {};
    }
    return list;
  }
}
