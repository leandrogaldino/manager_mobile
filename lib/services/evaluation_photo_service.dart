import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';

class EvaluationPhotoService implements Childable<EvaluationPhotoModel> {
  final EvaluationPhotoRepository _repository;

  EvaluationPhotoService({required EvaluationPhotoRepository repository}) : _repository = repository;

  @override
  Future<List<EvaluationPhotoModel>> getByParentId(dynamic parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => EvaluationPhotoModel.fromMap(item)).toList();
  }
}
