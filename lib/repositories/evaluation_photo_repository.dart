import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationPhotoRepository implements Childable {
  final LocalDatabase _localDatabase;

  EvaluationPhotoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(int parentId) async {
    var evaluationPhotos = await _localDatabase.query('evaluationphoto', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationPhotos;
  }
}
