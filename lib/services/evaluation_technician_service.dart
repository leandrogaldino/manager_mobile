import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';

class EvaluationTechnicianService implements Childable<EvaluationTechnicianModel> {
  final EvaluationTechnicianRepository _repository;

  EvaluationTechnicianService({required EvaluationTechnicianRepository repository}) : _repository = repository;

  @override
  Future<List<EvaluationTechnicianModel>> getByParentId(dynamic parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => EvaluationTechnicianModel.fromMap(item)).toList();
  }
}
