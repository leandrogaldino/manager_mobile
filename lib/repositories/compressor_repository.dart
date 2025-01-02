import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/repository.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';

class CompressorRepository implements Repository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  CompressorRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  @override
  Future<int> delete(int id) async {
    return await _localDatabase.delete('compressor', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    return _localDatabase.query('compressor');
  }

  @override
  Future<Map<String, dynamic>> getById(int id) async {
    final result = await _localDatabase.query('compressor', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return {};
    return result[0];
  }

  @override
  Future<List<Map<String, dynamic>>> getByLastUpdate(DateTime lastUpdate) async {
    final result = await _localDatabase.query('compressor', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
    return result;
  }

  @override
  Future<int> save(Map<String, dynamic> data) async {
    if (data['id'] == 0) {
      return await _localDatabase.insert('compressor', data);
    } else {
      await _localDatabase.update('compressor', data, where: 'id = ?', whereArgs: [data['id']]);
      return data['id'];
    }
  }

  @override
  Future<SyncronizeResultModel> syncronize() async {
    int count = 0;
    final lastSyncResult = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());
    final remoteResult = await _remoteDatabase.get(collection: 'coalescents', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
    for (var data in remoteResult) {
      final bool exists = await _localDatabase.isSaved('coalescent', id: data['id']);
      data.remove('documentid');
      if (exists) {
        await _localDatabase.update('coalescent', data, where: 'id = ?', whereArgs: [data['id']]);
      } else {
        await _localDatabase.insert('coalescent', data);
      }
      count += 1;
    }
    return SyncronizeResultModel(uploaded: count, downloaded: 0);
  }
}
