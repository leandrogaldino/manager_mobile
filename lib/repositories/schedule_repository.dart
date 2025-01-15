import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class ScheduleRepository implements Readable<Map<String, Object?>>, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CompressorRepository _compressorRepository;
  final PersonRepository _personRepository;
  final EvaluationRepository _evaluationRepository;
  ScheduleRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required CompressorRepository compressorRepository,
    required PersonRepository personRepository,
    required EvaluationRepository evaluationRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository,
        _personRepository = personRepository,
        _evaluationRepository = evaluationRepository;

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    List<Map<String, Object?>> schedules = await _localDatabase.query('schedule');
    for (var schedule in schedules) {
      schedule = await _processSchedule(schedule);
    }
    return schedules;
  }

  @override
  Future<Map<String, Object?>> getById(dynamic id) async {
    Map<String, Object?> schedule = await _localDatabase.query('schedule', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
    schedule = await _processSchedule(schedule);
    return schedule;
  }

  @override
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate) async {
    List<Map<String, Object?>> schedules = await _localDatabase.query('schedule', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
    for (var schedule in schedules) {
      schedule = await _processSchedule(schedule);
    }
    return schedules;
  }

  @override
  Future<SyncronizeResultModel> syncronize(int lastSync) async {
    int uploaded = await _syncronizeFromLocalToCloud(lastSync);
    int downloaded = await _syncronizeFromCloudToLocal(lastSync);
    return SyncronizeResultModel(uploaded: uploaded, downloaded: downloaded);
  }

  Future<Map<String, Object?>> _processSchedule(Map<String, Object?> scheduleData) async {
    var compressor = await _compressorRepository.getById(scheduleData['compressorid'] as int);
    scheduleData['compressor'] = compressor;
    scheduleData.remove('compressorid');
    var customer = await _personRepository.getById(compressor['personid'] as int);
    scheduleData['customer'] = customer;
    var evaluation = await _evaluationRepository.getById(scheduleData['evaluationid'].toString());
    scheduleData['evaluation'] = evaluation;
    scheduleData.remove('evaluationid');
    return scheduleData;
  }

  Future<int> _syncronizeFromLocalToCloud(int lastSync) async {
    await _localDatabase.delete('schedule');
    int uploadedData = 0;
    final localResult = await _localDatabase.query('schedule', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var scheduleMap in localResult) {
      await _remoteDatabase.set(collection: 'schedules', data: scheduleMap, id: scheduleMap['id'].toString());
      uploadedData += 1;
    }
    return uploadedData;
  }

  Future<int> _syncronizeFromCloudToLocal(int lastSync) async {
    int downloadedData = 0;
    bool exists = false;
    final remoteResult = await _remoteDatabase.get(collection: 'schedules', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
    for (var scheduleMap in remoteResult) {
      scheduleMap.remove('documentid');
      exists = await _localDatabase.isSaved('schedule', id: scheduleMap['id']);
      if (exists) {
        await _localDatabase.update('schedule', scheduleMap, where: 'id = ?', whereArgs: [scheduleMap['id']]);
      } else {
        await _localDatabase.insert('schedule', scheduleMap);
      }
      downloadedData += 1;
    }

    return downloadedData;
  }
}
