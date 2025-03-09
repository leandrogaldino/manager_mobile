import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService implements Readable<CompressorModel>, Syncronizable {
  final CompressorRepository _compressorRepository;

  CompressorService({required CompressorRepository compressorRepository}) : _compressorRepository = compressorRepository;

  @override
  Future<List<CompressorModel>> getAll() async {
    final data = await _compressorRepository.getAll();
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  Future<List<CompressorModel>> getVisibles() async {
    final data = await _compressorRepository.getVisibles();
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  @override
  Future<CompressorModel> getById(dynamic id) async {
    final data = await _compressorRepository.getById(id);
    if (data.isNotEmpty) {
      return CompressorModel.fromMap(data);
    } else {
      throw ServiceException('COM004', 'Compressor com o id $id não encontrado.');
    }
  }

  @override
  Future<void> synchronize(int lastSync) async {
    await _compressorRepository.synchronize(lastSync);
  }
}
