import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationTechnicianRepository {
  final LocalDatabase _localDatabase;

  EvaluationTechnicianRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      int id = await _localDatabase.insert('evaluationtechnician', data);
      data['id'] = id;
      return data;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'ETH001';
      String message = 'Erro ao salvar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationTechnicians = await _localDatabase.query('evaluationtechnician', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationTechnicians;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'ETH002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> deleteByParentId(dynamic parentId) async {
    try {
      return await _localDatabase.delete('evaluationtechnician', where: 'evaluationid = ?', whereArgs: [parentId]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'ETH003';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
