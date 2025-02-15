import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationPhotoRepository implements Childable, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationPhotoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    var evaluationPhotos = await _localDatabase.query('evaluationphoto', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationPhotos;
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    if (data['id'] == null || data['id'] == 0) {
      int id = await _localDatabase.insert('evaluationphoto', data);
      data['id'] = id;
      return data;
    } else {
      throw Exception('Essa foto já foi salva.');
    }
  }
}
