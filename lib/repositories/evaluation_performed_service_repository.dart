import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationPerformedServiceRepository {
  final LocalDatabase _localDatabase;

  EvaluationPerformedServiceRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
       bool exists = await _localDatabase.isSaved('evaluationperformedservice', id: data['id'] == null ? 0 : data['id'] as int);
      if (!exists) {
        int id = await _localDatabase.insert('evaluationperformedservice', data);
        data['id'] = id;
      } else {
        await _localDatabase.update('evaluationperformedservice', data, where: 'id = ?', whereArgs: [data['id']]);
      }
      return data;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EPF001';
      String message = 'Erro ao salvar os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationPerformedServices = await _localDatabase.query('evaluationperformedservice', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationPerformedServices;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EPF002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
