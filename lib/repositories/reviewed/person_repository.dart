import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/reviewed/personcompressor_repository.dart';

class PersonRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final PersonCompressorRepository _personCompressorRepository;

  PersonRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required PersonCompressorRepository personCompressorRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _personCompressorRepository = personCompressorRepository;

  Future<Map<String, Object?>> getById(dynamic id) async {
    try {
      final Map<String, Object?> person = await _localDatabase.query('person', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      var personCompressors = await _personCompressorRepository.getByParentId(id);
      person['personcompressors'] = personCompressors;
      return person;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PER001', 'Erro ao obter os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getTechnicians() async {
    try {
      var persons = await _localDatabase.query('person', where: 'istechnician = ?', whereArgs: ['1']);

      return persons;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PER002', 'Erro ao obter os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'persons', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
      for (var data in remoteResult) {
        final bool exists = await _localDatabase.isSaved('person', id: data['id']);
        data.remove('documentid');
        if (exists) {
          await _localDatabase.update('person', data, where: 'id = ?', whereArgs: [data['id']]);
        } else {
          await _localDatabase.insert('person', data);
        }
      }
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PER003', 'Erro ao sincronizar os dados: $e');
    }
  }
}
