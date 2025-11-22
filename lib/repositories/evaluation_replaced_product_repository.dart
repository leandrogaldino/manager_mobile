import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationReplacedProductRepository {
  final LocalDatabase _localDatabase;

  EvaluationReplacedProductRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      bool exists = await _localDatabase.isSaved('evvaluationreplacedproduct', id: data['id'] == null ? 0 : data['id'] as int);
      if (!exists) {
        int id = await _localDatabase.insert('evvaluationreplacedproduct', data);
        data['id'] = id;
      } else {
        await _localDatabase.update('evvaluationreplacedproduct', data, where: 'id = ?', whereArgs: [data['id']]);
      }
      return data;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'ERP001';
      String message = 'Erro ao salvar os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationReplacedProducts = await _localDatabase.query('evaluationreplacedproduct', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationReplacedProducts;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'ERP002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTime.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
