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
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    if (data['id'] == null || data['id'] == 0) {
      int id = await _localDatabase.insert('evaluationcoalescent', data);
      data['id'] = id;
      return data;
    } else {
      throw Exception('Esse coalescente já foi salvo.');
    }
  }
}
