import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationInfoRepository implements Childable, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationInfoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    var evaluationInfo = await _localDatabase.query('evaluationinfo', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationInfo;
  }

  @override
  Future<int> save(Map<String, Object?> data) async {
    if (data['id'] == 0) {
      int id = await _localDatabase.insert('evaluationinfo', data);
      return id;
    } else {
      await _localDatabase.update('evaluationinfo', data, where: 'id = ?', whereArgs: [data['id']]);
      return int.parse(data['id'].toString());
    }
  }
}
