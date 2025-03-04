import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/childable.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';

class CoalescentService implements Readable<CoalescentModel>, Childable<CoalescentModel>, Syncronizable {
  final CoalescentRepository _repository;

  CoalescentService({required CoalescentRepository repository}) : _repository = repository;

  @override
  Future<List<CoalescentModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => CoalescentModel.fromMap(item)).toList();
  }

  @override
  Future<CoalescentModel> getById(dynamic id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return CoalescentModel.fromMap(data);
    } else {
      throw ServiceException('COA005', 'Coalescente com o id $id não encontrado.');
    }
  }

  @override
  Future<List<CoalescentModel>> getByParentId(dynamic parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => CoalescentModel.fromMap(item)).toList();
  }

  @override
  Future<void> synchronize(int lastSync) async {
    await _repository.synchronize(lastSync);
  }
}
