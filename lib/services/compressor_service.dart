import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/reviewed/personcompressor_repository.dart';

class CompressorService {
  final PersonCompressorRepository _compressorRepository;

  CompressorService({required PersonCompressorRepository compressorRepository}) : _compressorRepository = compressorRepository;

  Future<List<PersonCompressorModel>> getVisibles() async {
    final data = await _compressorRepository.getVisibles();
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<void> synchronize(int lastSync) async {
    await _compressorRepository.synchronize(lastSync);
  }
}
