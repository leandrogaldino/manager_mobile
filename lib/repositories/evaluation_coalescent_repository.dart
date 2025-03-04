import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationCoalescentRepository implements Childable<Map<String, Object?>>, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationCoalescentRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationCoalescents = await _localDatabase.query('evaluationcoalescent', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationCoalescents;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('ECO001', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      if (data['id'] == null || data['id'] == 0) {
        int id = await _localDatabase.insert('evaluationcoalescent', data);
        data['id'] = id;
        return data;
      } else {
        throw RepositoryException('ECO002', 'Esse coalescente já foi salvo.');
      }
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('ECO003', 'Erro ao salvar os dados: $e');
    }
  }
}
