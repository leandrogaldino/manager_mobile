import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService implements Readable<CompressorModel>, Syncronizable {
  final CompressorRepository _repository;

  CompressorService({required CompressorRepository repository}) : _repository = repository;

  @override
  Future<List<CompressorModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  @override
  Future<CompressorModel> getById(dynamic id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return CompressorModel.fromMap(data);
    } else {
      throw ServiceException('COM004', 'Compressor com o id $id não encontrado.');
    }
  }

  @override
  Future<void> synchronize(int lastSync) async {
    await _repository.synchronize(lastSync);
  }
}
