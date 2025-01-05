import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class EvaluationTechnicianRepository implements Childable {
  final LocalDatabase _localDatabase;

  EvaluationTechnicianRepository({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  @override
  Future<List<Map<String, Object?>>> getByParentId(int parentId) async {
    var evaluationTechnicians = await _localDatabase.query('evaluationtechnician', where: 'evaluationid = ?', whereArgs: [parentId]);
    return evaluationTechnicians;
  }
}
