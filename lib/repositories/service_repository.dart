import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';

class ServiceRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  ServiceRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final Map<String, Object?> service = await _localDatabase.query('service', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });

      return service;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SER001';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    List<int>? remove,
  }) async {
    try {
      String where = 'visible = ?';
      List<Object?> whereArgs = [1];
      if (search != null && search.trim().isNotEmpty) {
        where += ' AND name LIKE ?';
        whereArgs.add('%$search%');
      }
      if (remove != null && remove.isNotEmpty) {
        final placeholders = List.filled(remove.length, '?').join(',');
        where += ' AND id NOT IN ($placeholders)';
        whereArgs.addAll(remove);
      }
      var services = await _localDatabase.query('service', where: where, whereArgs: whereArgs, limit: limit, offset: offset);
      return services;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SER002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(int lastSync) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTimeHelper.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'services',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('service', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('service', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('service', data);
          }
          count += 1;
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'services',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: startTime)],
        );
        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SER003';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
