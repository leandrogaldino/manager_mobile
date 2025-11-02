import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService {
  final CompressorRepository _compressorRepository;

  CompressorService({required CompressorRepository compressorRepository}) : _compressorRepository = compressorRepository;

  Future<int> synchronize(int lastSync) async {
    return await _compressorRepository.synchronize(lastSync);
  }
}
