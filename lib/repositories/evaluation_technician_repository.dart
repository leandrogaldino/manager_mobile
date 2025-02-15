import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/writable.dart';

class EvaluationTechnicianRepository implements Childable, Writable<Map<String, Object?>> {
  final LocalDatabase _localDatabase;

  EvaluationTechnicianRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(dynamic parentId) async {
    var evaluationTechnicians = await _localDatabase.query('evaluationtechnician', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationTechnicians;
  }

  @override
  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    if (data['id'] == null || data['id'] == 0) {
      int id = await _localDatabase.insert('evaluationtechnician', data);
      data['id'] = id;
      return data;
    } else {
      throw Exception('Esse técnico já foi salvo.');
    }
  }
}
