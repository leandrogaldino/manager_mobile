import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';

import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';

class CoalescentRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  CoalescentRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final result = await _localDatabase.query('coalescent', where: 'id = ?', whereArgs: [id]);
      if (result.isEmpty) return {};
      return result[0];
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA001', 'Erro ao obter os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      final result = await _localDatabase.query('coalescent', where: 'personcompressorid = ?', whereArgs: [parentId]);
      return result;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA002', 'Erro ao obter os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'personcompressorcoalescents', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
      for (var data in remoteResult) {
        final bool exists = await _localDatabase.isSaved('coalescent', id: data['id']);
        data.remove('documentid');
        if (exists) {
          await _localDatabase.update('coalescent', data, where: 'id = ?', whereArgs: [data['id']]);
        } else {
          await _localDatabase.insert('coalescent', data);
        }
      }
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA003', 'Erro ao sincronizar os dados: $e');
    }
  }
}
