import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
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

  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final Map<String, Object?> compressor = await _localDatabase.query('compressor', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });

      return compressor;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SCOM001', 'Erro ao obter os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'compressors', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
      for (var data in remoteResult) {
        final bool exists = await _localDatabase.isSaved('compressor', id: data['id']);
        data.remove('documentid');
        if (exists) {
          await _localDatabase.update('compressor', data, where: 'id = ?', whereArgs: [data['id']]);
        } else {
          await _localDatabase.insert('compressor', data);
        }
      }
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COM003', 'Erro ao sincronizar os dados: $e');
    }
  }
}
