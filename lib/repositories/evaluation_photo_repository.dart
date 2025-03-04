import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationPhotoRepository implements Childable, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationPhotoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    try {
      var evaluationPhotos = await _localDatabase.query('evaluationphoto', where: 'evaluationid = ?', whereArgs: [parentId]);
      return evaluationPhotos;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EPH001', 'Erro ao obter os dados: $e');
    }
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      if (data['id'] == null || data['id'] == 0) {
        int id = await _localDatabase.insert('evaluationphoto', data);
        data['id'] = id;
        return data;
      } else {
        throw RepositoryException('EPH002', 'Essa foto já foi salva.');
      }
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EPH003', 'Erro ao salvar os dados: $e');
    }
  }
}
