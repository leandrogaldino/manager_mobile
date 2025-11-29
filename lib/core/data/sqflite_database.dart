import 'dart:developer';
import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/core/constants/sql_scripts.dart';
import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SqfliteDatabase implements LocalDatabase {
  late Database _database;
  @override
  Future<void> init({bool inMemory = false}) async {
    try {
      _database = await openDatabase(
        inMemory ? inMemoryDatabasePath : join(await getDatabasesPath(), 'data.db'),
        password: 'sG7!pX9r#Qw2*zV8@Lf4^tY1*Hj5%kN0',
        version: 1,
        onCreate: (db, version) async {
          await db.execute(SQLScripts.createTablePreferences);
          await db.execute(SQLScripts.createTablePerson);
          await db.execute(SQLScripts.createTableCompressor);
          await db.execute(SQLScripts.createTablePersonCompressor);
          await db.execute(SQLScripts.createTableProduct);
          await db.execute(SQLScripts.createTableProductCode);
          await db.execute(SQLScripts.createTableService);
          await db.execute(SQLScripts.createTablePersonCompressorCoalescent);
          await db.execute(SQLScripts.createTableEvaluation);
          await db.execute(SQLScripts.createTableEvaluationReplacedProduct);
          await db.execute(SQLScripts.createTableEvaluationPerformedService);
          await db.execute(SQLScripts.createTableEvaluationTechnician);
          await db.execute(SQLScripts.createTableEvaluationCoalescent);
          await db.execute(SQLScripts.createTableEvaluationPhoto);
          await db.execute(SQLScripts.createTableSchedule);
          await db.execute(SQLScripts.insertThemePreference);
          await db.execute(SQLScripts.insertLastSyncPreference);
          await db.execute(SQLScripts.insertLoggedTechnicianIdPreference);
          await db.execute( SQLScripts.insertIgnoreLastSynchronizePreference);
          await db.execute( SQLScripts.insertSyncLockTimePreference);
        },
      );
    } on DatabaseException catch (e, s) {
      String code = 'LDB001';
      String message = 'Falha ao inicializar o banco de dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    try {
      int deletedRows = await _database.delete(table, where: where, whereArgs: whereArgs);
      return deletedRows;
    } catch (e, s) {
      String code = 'LDB002';
      String message = 'Erro ao excluir registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<dynamic> insert(String table, Map<String, Object?> values) async {
    try {
      dynamic lastInsertedId = await _database.insert(table, values);
      return lastInsertedId;
    } catch (e, s) {
      String code = 'LDB003';
      String message = 'Erro ao salvar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<dynamic> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs}) async {
    try {
      int changes = await _database.update(table, values, where: where, whereArgs: whereArgs);
      return changes;
    } catch (e, s) {
      String code = 'LDB004';
      String message = 'Erro ao atualizar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<List<Map<String, Object?>>> query(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset}) async {
    try {
      List<Map<String, Object?>> result = await _database.query(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset);
      return _resultSetToRawResult(result);
    } catch (e, s) {
      String code = 'LDB005';
      String message = 'Erro ao consultar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    try {
      int deletedRows = await _database.rawDelete(sql, arguments);
      return deletedRows;
    } catch (e, s) {
      String code = 'LDB006';
      String message = 'Erro ao excluir registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<dynamic> rawInsert(String sql, [List<Object?>? arguments]) async {
    try {
      int lastinsertedidd = await _database.rawInsert(sql, arguments);
      return lastinsertedidd;
    } catch (e, s) {
      String code = 'LDB007';
      String message = 'Erro ao salvar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) async {
    try {
      List<Map<String, Object?>> result = await _database.rawQuery(sql, arguments);
      return _resultSetToRawResult(result);
    } catch (e, s) {
      String code = 'LDB008';
      String message = 'Erro ao consultar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<dynamic> rawUpdate(String sql, [List<Object?>? arguments]) async {
    try {
      int changes = await _database.rawUpdate(sql, arguments);
      return changes;
    } catch (e, s) {
      String code = 'LDB009';
      String message = 'Erro ao atualizar registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
    }
  }

  @override
  Future<bool> isSaved(String table, {required dynamic id}) async {
    try {
      final data = await _database.query(table, where: 'id = ?', whereArgs: [id]);
      if (data.isEmpty) return false;
      return true;
    } catch (e, s) {
      String code = 'LDB010';
      String message = 'Erro ao verificar a existência do registro';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw LocalDatabaseException(code, message);
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
