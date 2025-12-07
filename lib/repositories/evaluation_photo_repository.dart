import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationPhotoRepository {
  final LocalDatabase _localDatabase;

  EvaluationPhotoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
       bool exists = await _localDatabase.isSaved('evaluationphoto', id: data['id'] == null ? 0 : data['id'] as int);
      if (!exists) {
        int id = await _localDatabase.insert('evaluationphoto', data);
        data['id'] = id;
      } else {
        await _localDatabase.update('evaluationphoto', data, where: 'id = ?', whereArgs: [data['id']]);
      }
      return data;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EPH001';
      String message = 'Erro ao salvar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationPhotos = await _localDatabase.query('evaluationphoto', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationPhotos;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EPH002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
