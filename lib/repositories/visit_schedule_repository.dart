import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class VisitScheduleRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final PersonCompressorRepository _compressorRepository;
  final PersonRepository _personRepository;
  VisitScheduleRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required PersonCompressorRepository compressorRepository,
    required PersonRepository personRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _compressorRepository = compressorRepository,
        _personRepository = personRepository;

  Future<List<Map<String, Object?>>> getVisibles() async {
    try {
      List<Map<String, Object?>> schedules = await _localDatabase.query('visitschedule', where: 'visible = ?', whereArgs: [1]);
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
      List<Map<String, Object?>> schedules = await _localDatabase.query('visitschedule');
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

  Future<int> delete(int id) async {
    try {
      return await _localDatabase.delete('visitschedule', where: 'id = ?', whereArgs: [id as String]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC003', 'Erro ao deletar os dados: $e');
    }
  }

  Future<int> synchronize(int lastSync) async {
    int count = 0;
    try {
      count = await _synchronizeFromLocalToCloud(lastSync);
      count += await _synchronizeFromCloudToLocal(lastSync);
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC004', 'Erro ao sincronizar os dados: $e');
    }
  }

  Future<Map<String, Object?>> _processSchedule(Map<String, Object?> scheduleData) async {
    var technician = await _personRepository.getById(scheduleData['technicianid'] as int);
    scheduleData['technician'] = technician;
    scheduleData.remove('technicianid');
    var compressor = await _compressorRepository.getById(scheduleData['compressorid'] as int);
    scheduleData['compressor'] = compressor;
    scheduleData.remove('compressorid');
    var customer = await _personRepository.getById(scheduleData['customerid'] as int);
    scheduleData['customer'] = customer;
    scheduleData.remove('customerid');
    return scheduleData;
  }

  Future<int> _synchronizeFromLocalToCloud(int lastSync) async {
    final localResult = await _localDatabase.query('visitschedule', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var scheduleMap in localResult) {
      scheduleMap['lastupdate'] =DateTime.now().millisecondsSinceEpoch;
      await _remoteDatabase.set(collection: 'visitschedules', data: scheduleMap, id: scheduleMap['id'].toString());
    }
    return localResult.length;
  }

  Future<int> _synchronizeFromCloudToLocal(int lastSync) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTime.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'visitschedules',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('visitschedule', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('visitschedule', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('visitschedule', data);
          }
          count += 1;
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'visitschedules',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: startTime)],
        );
        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC005', 'Erro ao sincronizar os dados: $e');
    }
  }

  Future<void> updateVisibility(int scheduleId, bool isVisible) async {
    try {
      await _localDatabase.update('visitschedule', {'visible': isVisible == true ? 1 : 0, 'performeddate': DateTime.now().millisecondsSinceEpoch, 'lastupdate': DateTime.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [scheduleId]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('SHC006', 'Erro ao atualizar: $e');
    }
  }
}
