import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/repository.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class PersonRepository implements Repository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CompressorRepository _compressorRepository;

  PersonRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase, required CompressorRepository compressorRepository})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository;

  @override
  Future<int> delete(int id) async {
    return await _localDatabase.delete('person', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    var persons = await _localDatabase.query('person');
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  @override
  Future<Map<String, Object?>> getById(int id) async {
    final Map<String, Object?> person = await _localDatabase.query('person', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
    var compressors = await _compressorRepository.getByParentId(person['id'] as int);
    person['compressors'] = compressors;
    return person;
  }

  @override
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate) async {
    var persons = await _localDatabase.query('person', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  @override
  Future<int> save(Map<String, Object?> data) async {
    if (data['id'] == 0) {
      return await _localDatabase.insert('person', data);
    } else {
      await _localDatabase.update('person', data, where: 'id = ?', whereArgs: [data['id']]);
      return data['id'] as int;
    }
  }

  @override
  Future<SyncronizeResultModel> syncronize() async {
    int count = 0;
    final lastSyncResult = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());
    final remoteResult = await _remoteDatabase.get(collection: 'persons', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
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
    return SyncronizeResultModel(uploaded: 0, downloaded: count);
  }
}