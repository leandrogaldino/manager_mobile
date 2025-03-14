import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class ScheduleRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final CompressorRepository _compressorRepository;
  final PersonRepository _personRepository;
  ScheduleRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required CompressorRepository compressorRepository,
    required PersonRepository personRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository,
        _personRepository = personRepository;

  Future<List<Map<String, Object?>>> getVisibles() async {
    try {
      List<Map<String, Object?>> schedules = await _localDatabase.query('schedule', where: 'visible = ?', whereArgs: [1]);
      for (var schedule in schedules) {
        schedule = await _processSchedule(schedule);
      }
      return schedules;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC001', 'Erro ao obter os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getAll() async {
    try {
      List<Map<String, Object?>> schedules = await _localDatabase.query('schedule');
      for (var schedule in schedules) {
        schedule = await _processSchedule(schedule);
      }
      return schedules;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC002', 'Erro ao obter os dados: $e');
    }
  }

  Future<int> delete(dynamic id) async {
    try {
      return await _localDatabase.delete('schedule', where: 'id = ?', whereArgs: [id as String]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC003', 'Erro ao deletar os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      await _synchronizeFromLocalToCloud(lastSync);
      await _synchronizeFromCloudToLocal(lastSync);
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC004', 'Erro ao sincronizar os dados: $e');
    }
  }

  Future<Map<String, Object?>> _processSchedule(Map<String, Object?> scheduleData) async {
    var compressor = await _compressorRepository.getById(scheduleData['personcompressorid'] as int);
    scheduleData['compressor'] = compressor;
    scheduleData.remove('personcompressorid');
    var customer = await _personRepository.getById(compressor['personid'] as int);
    scheduleData['customer'] = customer;
    return scheduleData;
  }

  Future<int> _synchronizeFromLocalToCloud(int lastSync) async {
    int uploadedData = 0;
    final localResult = await _localDatabase.query('schedule', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var scheduleMap in localResult) {
      await _remoteDatabase.set(collection: 'schedules', data: scheduleMap, id: scheduleMap['id'].toString());
      uploadedData += 1;
    }
    return uploadedData;
  }

  Future<int> _synchronizeFromCloudToLocal(int lastSync) async {
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

  Future<void> updateVisibility(int scheduleId, bool isVisible) async {
    try {
      await _localDatabase.update('schedule', {'visible': isVisible == true ? 1 : 0, 'lastupdate': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [scheduleId]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC005', 'Erro ao atualizar: $e');
    }
  }
}
