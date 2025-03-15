import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationPhotoRepository {
  final LocalDatabase _localDatabase;

  EvaluationPhotoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      if (data['id'] == null || data['id'] == 0) {
        int id = await _localDatabase.insert('evaluationphoto', data);
        data['id'] = id;
        return data;
      } else {
        throw RepositoryException('EPH001', 'Essa foto já foi salva.');
      }
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EPH002', 'Erro ao salvar os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationPhotos = await _localDatabase.query('evaluationphoto', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationPhotos;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EPH003', 'Erro ao obter os dados: $e');
    }
  }
}
