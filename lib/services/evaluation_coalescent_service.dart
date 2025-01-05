import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';

class EvaluationCoalescentService implements Childable<EvaluationCoalescentModel> {
  final EvaluationCoalescentRepository _repository;

  EvaluationCoalescentService({required EvaluationCoalescentRepository repository}) : _repository = repository;

  @override
  Future<List<EvaluationCoalescentModel>> getByParentId(dynamic parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => EvaluationCoalescentModel.fromMap(item)).toList();
  }
}
