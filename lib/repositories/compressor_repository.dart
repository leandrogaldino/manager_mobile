import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';

class CompressorRepository implements Readable<Map<String, Object?>>, Childable<Map<String, Object?>>, Writable<Map<String, Object?>>, Deletable, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CoalescentRepository _coalescentRepository;

  CompressorRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase, required CoalescentRepository coalescentRepository})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _coalescentRepository = coalescentRepository;

  @override
  Future<int> delete(dynamic id) async {
    return await _localDatabase.delete('compressor', where: 'id = ?', whereArgs: [id as int]);
  }

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    var compressors = await _localDatabase.query('compressor');
    for (var compressor in compressors) {
      var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
      compressor['coalescents'] = coalescents;
    }
    return compressors;
  }

  @override
  Future<Map<String, Object?>> getById(int id) async {
    final Map<String, Object?> compressor = await _localDatabase.query('compressor', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
    var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
    compressor['coalescents'] = coalescents;
    return compressor;
  }

  @override
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate) async {
    var compressors = await _localDatabase.query('compressor', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
    for (var compressor in compressors) {
      var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
      compressor['coalescents'] = coalescents;
    }
    return compressors;
  }

  @override
  Future<List<Map<String, Object?>>> getByParentId(int parentId) async {
    var compressors = await _localDatabase.query('compressor', where: 'personid = ?', whereArgs: [parentId]);
    for (var compressor in compressors) {
      var coalescents = await _coalescentRepository.getByParentId(compressor['id'] as int);
      compressor['coalescents'] = coalescents;
    }
    return compressors;
  }

  @override
  Future<int> save(Map<String, Object?> data) async {
    if (data['id'] == 0) {
      return await _localDatabase.insert('compressor', data);
    } else {
      await _localDatabase.update('compressor', data, where: 'id = ?', whereArgs: [data['id']]);
      return data['id'] as int;
    }
  }

  @override
  Future<SyncronizeResultModel> syncronize(int lastSync) async {
    int count = 0;
    final remoteResult = await _remoteDatabase.get(collection: 'compressors', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
    for (var data in remoteResult) {
      final bool exists = await _localDatabase.isSaved('compressor', id: data['id']);
      data.remove('documentid');
      if (exists) {
        await _localDatabase.update('compressor', data, where: 'id = ?', whereArgs: [data['id']]);
      } else {
        await _localDatabase.insert('compressor', data);
      }
      count += 1;
    }
    return SyncronizeResultModel(uploaded: 0, downloaded: count);
  }
}
