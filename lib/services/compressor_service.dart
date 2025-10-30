import 'package:manager_mobile/repositories/compressor_repository.dart';

class CompressorService {
  final CompressorRepository _compressorRepository;

  CompressorService({required CompressorRepository compressorRepository}) : _compressorRepository = compressorRepository;

  Future<void> synchronize(int lastSync) async {
    await _compressorRepository.synchronize(lastSync);
  }
}
