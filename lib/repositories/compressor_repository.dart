import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';

class CompressorRepository implements Readable<Map<String, Object?>>, Childable<Map<String, Object?>>, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CoalescentRepository _coalescentRepository;

  CompressorRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase, required CoalescentRepository coalescentRepository})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _coalescentRepository = coalescentRepository;

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    try {
      var compressors = await _localDatabase.query('compressor');
      for (var compressor in compressors) {
        var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
        compressor['coalescents'] = coalescents;
      }
      return compressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COM001', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final Map<String, Object?> compressor = await _localDatabase.query('compressor', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
      compressor['coalescents'] = coalescents;
      return compressor;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COM002', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var compressors = await _localDatabase.query('compressor', where: 'personid = ?', whereArgs: [parentId]);
      for (var compressor in compressors) {
        var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
        compressor['coalescents'] = coalescents;
      }
      return compressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COM003', 'Erro ao obter os dados: $e');
    }
  }

  @override
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
      throw RepositoryException('COM004', 'Erro ao sincronizar os dados: $e');
    }
  }
}
