import 'dart:developer';
import 'package:manager_mobile/core/data/database_migrations.dart';
import 'package:manager_mobile/core/data/database_schema.dart';
import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase implements LocalDatabase {
  late Database _database;

  @override
  Future<void> init({bool inMemory = false}) async {
    try {
      const currentVersion = 2;
      final path = inMemory ? inMemoryDatabasePath : join(await getDatabasesPath(), 'data.db');
      _database = await openDatabase(
        path,
        version: currentVersion,
        onCreate: (db, version) async {
          await DatabaseSchema.create(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          await DatabaseMigrations.migrate(
            db,
            oldVersion,
            newVersion,
          );
        },
      );
    } on DatabaseException catch (e, s) {
      String code = 'LDB001';
      String message = 'Falha ao inicializar o banco de dados';

      log(
        '[$code] $message',
        time: DateTimeHelper.now(),
        error: e,
        stackTrace: s,
      );

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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
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
