import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';

class PersonRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  PersonRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  Future<Map<String, Object?>> getById(int id) async {
    try {
      final Map<String, Object?> person = await _localDatabase.query('person', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      return person;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PER001';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getTechnicians() async {
    try {
      var persons = await _localDatabase.query('person', where: 'istechnician = ?', whereArgs: ['1']);
      return persons;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PER002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(int lastSync) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTime.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'persons',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('person', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('person', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('person', data);
          }
          count += 1;
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'persons',
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
      String code = 'PER003';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
