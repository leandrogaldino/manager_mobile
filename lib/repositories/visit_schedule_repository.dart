import 'dart:developer';
import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
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

  Future<DateTime> get minimumDate async {
    DateTime minDate;
    var result = await _localDatabase.rawQuery('''
      SELECT MIN(creationdate) AS oldest
      FROM visitschedule;
      ''');
    if (result.isEmpty || result[0]['oldest'] == null) {
      minDate = DateTime(2000, 1, 1);
    } else {
      minDate = DateTimeHelper.fromMillisecondsSinceEpoch(result[0]['oldest'] as int);
    }
    return minDate;
  }

  Future<DateTime> get maximumDate async {
    DateTime maxDate;
    var result = await _localDatabase.rawQuery('''
      SELECT MAX(creationdate) AS newest
      FROM visitschedule;
      ''');
    if (result.isEmpty || result[0]['newest'] == null) {
      maxDate = DateTime(2100, 1, 1);
    } else {
      maxDate = DateTimeHelper.fromMillisecondsSinceEpoch(result[0]['newest'] as int);
    }
    return maxDate;
  }

  Future<List<Map<String, Object?>>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    DateTime? initialDate,
    DateTime? finalDate,
  }) async {
    try {
      String where = 's.visible = ?';
      List<Object?> whereArgs = [1];
      if (search != null && search.trim().isNotEmpty) {
        where += ' AND (c.name LIKE ? OR p.shortname LIKE ? OR pc.serialnumber LIKE ? OR pc.patrimony LIKE ? OR pc.sector LIKE ?)';
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
      }
       if (initialDate != null) {
        final start = DateTime(
          initialDate.year,
          initialDate.month,
          initialDate.day,
        );

        where += ' AND s.creationdate >= ?';
        whereArgs.add(start.millisecondsSinceEpoch);
      }

      if (finalDate != null) {
        final endExclusive = DateTime(
          finalDate.year,
          finalDate.month,
          finalDate.day + 1,
        );

        where += ' AND s.creationdate < ?';
        whereArgs.add(endExclusive.millisecondsSinceEpoch);
      }

      whereArgs.addAll([limit, offset]);

      List<Map<String, Object?>> schedules = await _localDatabase.rawQuery(
        '''
      SELECT s.* FROM visitschedule s
      JOIN person p ON p.id = s.customerid
      JOIN personcompressor pc ON pc.id = s.compressorid
      JOIN compressor c ON c.id = pc.compressorid
      WHERE $where
      ORDER BY s.creationdate DESC
      LIMIT ? OFFSET ?;
      ''',
        whereArgs,
      );

      for (int i = 0; i < schedules.length; i++) {
        schedules[i] = await _processSchedule(schedules[i]);
      }
      return schedules;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SHC001';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
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
    } on Exception catch (e, s) {
      String code = 'SHC002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> delete(int id) async {
    try {
      return await _localDatabase.delete('visitschedule', where: 'id = ?', whereArgs: [id as String]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SHC003';
      String message = 'Erro ao deletar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
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

  Future<int> synchronize(
    int lastSync, {
    void Function(int visitScheduleId)? onItemSynced,
  }) async {
    int count = 0;
    try {
      count = await _synchronizeFromLocalToCloud(lastSync, onItemSynced: onItemSynced);
      count += await _synchronizeFromCloudToLocal(lastSync, onItemSynced: onItemSynced);
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SHC004';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> _synchronizeFromLocalToCloud(
    int lastSync, {
    void Function(int visitScheduleId)? onItemSynced,
  }) async {
    final localResult = await _localDatabase.query('visitschedule', where: 'lastupdate > ?', whereArgs: [lastSync]);

    for (var scheduleMap in localResult) {
      scheduleMap['lastupdate'] = DateTimeHelper.now().millisecondsSinceEpoch;

      await _remoteDatabase.set(
        collection: 'visitschedules',
        data: scheduleMap,
        id: scheduleMap['id'].toString(),
      );

      // 🔥 callback por item sincronizado
      onItemSynced?.call(scheduleMap['id'] as int);
    }

    return localResult.length;
  }

  Future<int> _synchronizeFromCloudToLocal(
    int lastSync, {
    void Function(int visitScheduleId)? onItemSynced,
  }) async {
    int count = 0;

    try {
      bool hasMore = true;

      while (hasMore) {
        final int startTime = DateTimeHelper.now().millisecondsSinceEpoch;

        final remoteResult = await _remoteDatabase.get(
          collection: 'visitschedules',
          filters: [
            RemoteDatabaseFilter(
              field: 'lastupdate',
              operator: FilterOperator.isGreaterThan,
              value: lastSync,
            ),
          ],
        );

        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }

        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('visitschedule', id: data['id']);
          data.remove('documentid');

          if (exists) {
            await _localDatabase.update(
              'visitschedule',
              data,
              where: 'id = ?',
              whereArgs: [data['id']],
            );
          } else {
            await _localDatabase.insert('visitschedule', data);
          }

          count += 1;

          // 🔥 callback por item sincronizado
          onItemSynced?.call(data['id'] as int);
        }

        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);

        final newer = await _remoteDatabase.get(
          collection: 'visitschedules',
          filters: [
            RemoteDatabaseFilter(
              field: 'lastupdate',
              operator: FilterOperator.isGreaterThan,
              value: startTime,
            ),
          ],
        );

        hasMore = newer.isNotEmpty;
      }

      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SHC005';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<void> updateVisibility(int scheduleId, bool isVisible) async {
    try {
      await _localDatabase.update('visitschedule', {'visible': isVisible == true ? 1 : 0, 'performeddate': DateTimeHelper.now().millisecondsSinceEpoch, 'lastupdate': DateTimeHelper.now().millisecondsSinceEpoch}, where: 'id = ?', whereArgs: [scheduleId]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'SHC006';
      String message = 'Erro ao atualizar';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
