import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationCoalescentRepository implements Childable<Map<String, Object?>>, Writable<Map<String, Object?>>, Deletable {
  final LocalDatabase _localDatabase;

  EvaluationCoalescentRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    var evaluationCoalescents = await _localDatabase.query('evaluationcoalescent', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationCoalescents;
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    if (data['id'] == '') {
      int id = await _localDatabase.insert('evaluationcoalescent', data);
      data['id'] = id;
      return data;
    } else {
      await _localDatabase.update('evaluationcoalescent', data, where: 'id = ?', whereArgs: [data['id']]);
      return data;
    }
  }

  @override
  Future<int> delete(dynamic id) async {
    return await _localDatabase.delete('evaluationcoalescent', where: 'id = ?', whereArgs: [id as int]);
  }
}
