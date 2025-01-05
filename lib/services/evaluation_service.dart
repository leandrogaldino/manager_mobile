import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';

class EvaluationService implements Readable<EvaluationModel>, Writable<EvaluationModel>, Deletable, Syncronizable {
  final EvaluationRepository _repository;

  EvaluationService({required EvaluationRepository repository}) : _repository = repository;

  @override
  Future<int> delete(dynamic id) async {
    return await _repository.delete(id as int);
  }

  @override
  Future<List<EvaluationModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  @override
  Future<EvaluationModel> getById(int id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return EvaluationModel.fromMap(data);
    } else {
      throw ServiceException('Avaliação com o id $id não encontrada.');
    }
  }

  @override
  Future<List<EvaluationModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _repository.getByLastUpdate(lastUpdate);
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  @override
  Future<String> save(EvaluationModel model) async {
    final data = model.toMap();
    return await _repository.save(data);
  }

  @override
  Future<SyncronizeResultModel> syncronize(lastSync) async {
    return _repository.syncronize(lastSync);
  }
}
