import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationInfoRepository implements Childable {
  final LocalDatabase _localDatabase;

  EvaluationInfoRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(int parentId) async {
    var evaluationCoalescents = await _localDatabase.query('evaluationinfo', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationCoalescents;
  }
}
