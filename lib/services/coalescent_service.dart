import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/service.dart';
import 'package:manager_mobile/interfaces/service_parent.dart';
import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';

class CoalescentService implements Service<CoalescentModel>, ServiceParent<CoalescentModel> {
  final CoalescentRepository _repository;

  CoalescentService({required CoalescentRepository repository}) : _repository = repository;

  @override
  Future<int> delete(int id) async {
    return await _repository.delete(id);
  }

  @override
  Future<List<CoalescentModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => CoalescentModel.fromMap(item)).toList();
  }

  @override
  Future<CoalescentModel> getById(int id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return CoalescentModel.fromMap(data);
    } else {
      throw ServiceException('Coalescente com o id $id não encontrado.');
    }
  }

  @override
  Future<List<CoalescentModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _repository.getByLastUpdate(lastUpdate);
    return data.map((item) => CoalescentModel.fromMap(item)).toList();
  }

  @override
  Future<List<CoalescentModel>> getByParentId(int parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => CoalescentModel.fromMap(item)).toList();
  }

  @override
  Future<int> save(CoalescentModel model) async {
    final data = model.toMap();
    return await _repository.save(data);
  }

  @override
  Future<SyncronizeResultModel> syncronize() async {
    return _repository.syncronize();
  }
}