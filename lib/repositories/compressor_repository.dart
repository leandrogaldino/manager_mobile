import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';

class CompressorRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  CompressorRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  Future<Map<String, Object?>> getById(int id) async {
    try {
      final result = await _localDatabase.query(
        'compressor',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) return {};
      return result.first;
    } on LocalDatabaseException {
      rethrow;
    } catch (e, s) {
      const code = 'COM001';
      const message = 'Erro ao obter compressor';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(
    int lastSync, {
    void Function(int compressorId)? onItemSynced,
  }) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final startTime = DateTimeHelper.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'compressors',
          filters: [
            RemoteDatabaseFilter(
              field: 'lastupdate',
              operator: FilterOperator.isGreaterThan,
              value: lastSync,
            ),
          ],
        );
        if (remoteResult.isEmpty) break;
        for (final data in remoteResult) {
          final int id = data['id'] as int;
          final exists = await _localDatabase.isSaved('compressor', id: id);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update(
              'compressor',
              data,
              where: 'id = ?',
              whereArgs: [id],
            );
          } else {
            await _localDatabase.insert('compressor', data);
          }
          count++;
          onItemSynced?.call(id);
        }
        lastSync = remoteResult.map((e) => e['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'compressors',
          filters: [
            RemoteDatabaseFilter(
              field: 'lastupdate',
              operator: FilterOperator.isGreaterThan,
              value: startTime,
            ),
          ],
        );

        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } catch (e, s) {
      const code = 'COM002';
      const message = 'Erro ao sincronizar compressores';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
