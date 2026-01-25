import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';

class PersonCompressorRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final PersonRepository _personRepository;
  final CompressorRepository _compressorRepository;
  final PersonCompressorCoalescentRepository _personCompressorCoalescentRepository;

  PersonCompressorRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required PersonRepository personRepository,
    required CompressorRepository compressorRepository,
    required PersonCompressorCoalescentRepository personCompressorCoalescentRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _personRepository = personRepository,
        _compressorRepository = compressorRepository,
        _personCompressorCoalescentRepository = personCompressorCoalescentRepository;

  Future<List<Map<String, Object?>>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
  }) async {
    try {
      String where = 'pc.visible = ?';
      List<Object?> whereArgs = [1];

      if (search != null && search.trim().isNotEmpty) {
        where += ' AND (c.name LIKE ? OR p.shortname LIKE ? OR pc.serialnumber LIKE ? OR pc.patrimony LIKE ? OR pc.sector LIKE ?)';
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
      }
      whereArgs.addAll([limit, offset]);

      var personcompressors = await _localDatabase.rawQuery('''
        SELECT pc.*
        FROM personcompressor pc
        JOIN compressor c ON c.id = pc.compressorid
        JOIN person p ON p.id = pc.personid
        WHERE $where
        ORDER BY p.shortname ASC
        LIMIT ? OFFSET ?;
        ''', whereArgs);

      for (var personCompressor in personcompressors) {
        final compressorId = personCompressor['compressorid'] as int;
        personCompressor.remove('compressorid');
        final compressor = await _compressorRepository.getById(compressorId);
        personCompressor['compressor'] = compressor;
        var personId = personCompressor['personid'] as int;
        personCompressor.remove('personid');
        var person = await _personRepository.getById(personId);
        personCompressor['person'] = person;
        var personCompressorId = personCompressor['id'] as int;
        var coalescents = await _personCompressorCoalescentRepository.getByPersonCompressorId(personCompressorId);
        personCompressor['coalescents'] = coalescents;
      }
      return personcompressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PCO001';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<Map<String, Object?>> getById(int id) async {
    try {
      final Map<String, Object?> personCompressor = await _localDatabase.query('personcompressor', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      final compressorId = personCompressor['compressorid'] as int;
      personCompressor.remove('compressorid');
      final compressor = await _compressorRepository.getById(compressorId);
      personCompressor['compressor'] = compressor;
      var personId = personCompressor['personid'] as int;
      personCompressor.remove('personid');
      var person = await _personRepository.getById(personId);
      personCompressor['person'] = person;
      var personCompressorId = personCompressor['id'] as int;
      var coalescents = await _personCompressorCoalescentRepository.getByPersonCompressorId(personCompressorId);
      personCompressor['coalescents'] = coalescents;
      return personCompressor;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PCO002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getByPersonId(int personId) async {
    try {
      final personcompressors = await _localDatabase.query('personcompressor', where: 'personid = ?', whereArgs: [personId]);
      for (var personCompressor in personcompressors) {
        final compressorId = personCompressor['compressorid'] as int;
        personCompressor.remove('compressorid');
        final compressor = await _compressorRepository.getById(compressorId);
        personCompressor['compressor'] = compressor;
        var personId = personCompressor['personid'] as int;
        personCompressor.remove('personid');
        var person = await _personRepository.getById(personId);
        personCompressor['person'] = person;
        var personCompressorId = personCompressor['id'] as int;
        var coalescents = await _personCompressorCoalescentRepository.getByPersonCompressorId(personCompressorId);
        personCompressor['coalescents'] = coalescents;
      }
      return personcompressors;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PCO003';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(
    int lastSync, {
    void Function(int personCompressorId)? onItemSynced,
  }) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTimeHelper.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'personcompressors',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (final data in remoteResult) {
          final int id = data['id'] as int;
          final bool exists = await _localDatabase.isSaved('personcompressor', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('personcompressor', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('personcompressor', data);
          }
          count++;
          onItemSynced?.call(id);
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'personcompressors',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: startTime)],
        );
        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PCO004';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
