import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';

class ScheduleRepository implements Readable<ScheduleModel>, Writable<ScheduleModel>, Deletable, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  ScheduleRepository({required RemoteDatabase remoteDatabase, required LocalDatabase localDatabase})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  @override
  Future<int> delete(dynamic id) async {
    return await _localDatabase.delete('schedule', where: 'id = ?', whereArgs: [id as int]);
  }

  @override
  Future<List<ScheduleModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<ScheduleModel> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleModel>> getByLastUpdate(DateTime lastUpdate) {
    // TODO: implement getByLastUpdate
    throw UnimplementedError();
  }

  @override
  Future save(ScheduleModel data) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<SyncronizeResultModel> syncronize(int lastSync) {
    // TODO: implement syncronize
    throw UnimplementedError();
  }
}
