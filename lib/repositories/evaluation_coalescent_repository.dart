import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationCoalescentRepository implements Childable<Map<String, Object?>>, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationCoalescentRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    var evaluationCoalescents = await _localDatabase.query('evaluationcoalescent', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationCoalescents;
  }

  @override
  Future<int> save(Map<String, Object?> data) async {
    await Future.delayed(Duration(seconds: 2));
    return 0;
  }
}
