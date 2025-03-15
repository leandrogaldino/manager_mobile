import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService {
  final CompressorRepository _compressorRepository;

  CompressorService({required CompressorRepository compressorRepository}) : _compressorRepository = compressorRepository;

  Future<List<CompressorModel>> getVisibles() async {
    final data = await _compressorRepository.getVisibles();
    return data.map((item) => CompressorModel.fromMap(item)).toList();
  }

  Future<void> synchronize(int lastSync) async {
    await _compressorRepository.synchronize(lastSync);
  }
}
