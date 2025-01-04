import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/service.dart';
import 'package:manager_mobile/interfaces/service_parent.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService implements Service<CompressorModel>, ServiceParent<CompressorModel> {
  final CompressorRepository _repository;

  CompressorService({required CompressorRepository repository}) : _repository = repository;

  @override
  Future<int> delete(int id) async {
    return await _repository.delete(id);
  }

  @override
  Future<List<CompressorModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  @override
  Future<CompressorModel> getById(int id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return CompressorModel.fromMap(data);
    } else {
      throw ServiceException('Compressor com o id $id não encontrado.');
    }
  }

  @override
  Future<List<CompressorModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _repository.getByLastUpdate(lastUpdate);
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  @override
  Future<List<CompressorModel>> getByParentId(int parentId) async {
    final data = await _repository.getByParentId(parentId);
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  @override
  Future<int> save(CompressorModel model) async {
    final data = model.toMap();
    return await _repository.save(data);
  }

  @override
  Future<SyncronizeResultModel> syncronize() async {
    return _repository.syncronize();
  }
}
