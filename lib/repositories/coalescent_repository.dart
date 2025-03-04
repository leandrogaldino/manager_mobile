import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';

class CoalescentRepository implements Readable<Map<String, Object?>>, Childable<Map<String, Object?>>, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  CoalescentRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    try {
      return _localDatabase.query('coalescent');
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA001', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final result = await _localDatabase.query('coalescent', where: 'id = ?', whereArgs: [id]);
      if (result.isEmpty) return {};
      return result[0];
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA002', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      final result = await _localDatabase.query('coalescent', where: 'personcompressorid = ?', whereArgs: [parentId]);
      return result;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA003', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'coalescents', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
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
      throw RepositoryException('COA004', 'Erro ao sincronizar os dados: $e');
    }
  }
}
