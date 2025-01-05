import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationCoalescentRepository implements Childable {
  final LocalDatabase _localDatabase;

  EvaluationCoalescentRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(int parentId) async {
    var evaluationCoalescents = await _localDatabase.query('evaluationcoalescent', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationCoalescents;
  }
}
