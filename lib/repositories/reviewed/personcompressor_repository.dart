import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/reviewed/compressor_repository.dart';
import 'package:manager_mobile/repositories/reviewed/personcompressorcoalescent_repository.dart';

class PersonCompressorRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CompressorRepository _compressorRepository;
  final PersonCompressorCoalescentRepository _personCompressorCoalescentRepository;

  PersonCompressorRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required CompressorRepository compressorRepository,
    required PersonCompressorCoalescentRepository personCompressorCoalescentRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository,
        _personCompressorCoalescentRepository = personCompressorCoalescentRepository;

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      final personcompressors = await _localDatabase.query('personcompressor', where: 'personid = ?', whereArgs: [parentId]);

      for (var personcompressor in personcompressors) {
        final compressorId = personcompressor['compressorid'];
        final compressor = await _compressorRepository.getById(compressorId);
        personcompressor['compressor'] = compressor;
        var personCompressorId = personcompressor['id'];
        var coalescents = await _personCompressorCoalescentRepository.getByParentId(personCompressorId);
        personcompressor['coalescents'] = coalescents;
      }
      return personcompressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PCO001', 'Erro ao obter os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'personcompressors', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
      for (var data in remoteResult) {
        final bool exists = await _localDatabase.isSaved('personcompressor', id: data['id']);
        data.remove('documentid');
        if (exists) {
          await _localDatabase.update('personcompressor', data, where: 'id = ?', whereArgs: [data['id']]);
        } else {
          await _localDatabase.insert('personcompressor', data);
        }
      }
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PCO002', 'Erro ao sincronizar os dados: $e');
    }
  }
}
