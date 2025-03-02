import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class PersonRepository implements Readable<Map<String, Object?>>, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CompressorRepository _compressorRepository;

  PersonRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase, required CompressorRepository compressorRepository})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository;

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    var persons = await _localDatabase.query('person');
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  Future<List<Map<String, Object?>>> getCustomers() async {
    var persons = await _localDatabase.query('person', where: 'iscustomer = ?', whereArgs: ['1']);
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  Future<List<Map<String, Object?>>> getTechnicians() async {
    var persons = await _localDatabase.query('person', where: 'istechnician = ?', whereArgs: ['1']);
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  @override
  Future<Map<String, Object?>> getById(dynamic id) async {
    final Map<String, Object?> person = await _localDatabase.query('person', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
    var compressors = await _compressorRepository.getByParentId(person['id'] as int);
    person['compressors'] = compressors;
    return person;
  }

  @override
  Future<void> synchronize(int lastSync) async {
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
  }
}
