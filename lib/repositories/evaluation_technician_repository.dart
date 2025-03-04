import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationTechnicianRepository implements Childable, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationTechnicianRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationTechnicians = await _localDatabase.query('evaluationtechnician', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationTechnicians;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('ETH001', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      if (data['id'] == null || data['id'] == 0) {
        int id = await _localDatabase.insert('evaluationtechnician', data);
        data['id'] = id;
        return data;
      } else {
        throw RepositoryException('ETH002', 'Esse técnico já foi salvo.');
      }
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('ETH003', 'Erro ao salvar os dados: $e');
    }
  }
}
