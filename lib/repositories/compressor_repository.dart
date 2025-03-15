import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class CompressorRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CoalescentRepository _coalescentRepository;
  final PersonRepository _personRepository;

  CompressorRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required CoalescentRepository coalescentRepository,
    required PersonRepository personRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _coalescentRepository = coalescentRepository,
        _personRepository = personRepository;

  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final Map<String, Object?> compressor = await _localDatabase.query('compressor', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      var owner = await _personRepository.getById(compressor['personid'] as int);
      compressor['owner'] = owner;
      var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
      compressor['coalescents'] = coalescents;
      return compressor;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COM001', 'Erro ao obter os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getVisibles() async {
    try {
      var compressors = await _localDatabase.rawQuery('''
        SELECT c.id, c.personid, c.visible, c.compressorid, c.compressorname, c.serialnumber, c.sector, c.lastupdate
        FROM compressor c
        INNER JOIN person p ON p.id = c.personid
        WHERE c.visible = 1 AND p.visible = 1
        ''');
      for (var compressor in compressors) {
        var owner = await _personRepository.getById(compressor['personid'] as int);
        compressor['owner'] = owner;
        var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
        compressor['coalescents'] = coalescents;
      }
      return compressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EVA002', 'Erro ao obter os dados: $e');
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
