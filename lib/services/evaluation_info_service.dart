import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/models/evaluation_info_model.dart';
import 'package:manager_mobile/repositories/evaluation_info_repository.dart';

class EvaluationInfoService implements Childable<EvaluationInfoModel> {
  final EvaluationInfoRepository _repository;

  EvaluationInfoService({required EvaluationInfoRepository repository}) : _repository = repository;

  @override
  Future<List<EvaluationInfoModel>> getByParentId(dynamic parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => EvaluationInfoModel.fromMap(item)).toList();
  }
}
