import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';

class PersonCompressorService {
  final PersonCompressorRepository _personCompressorRepository;

  PersonCompressorService({required PersonCompressorRepository personCompressorRepository}) : _personCompressorRepository = personCompressorRepository;

  Future<List<PersonCompressorModel>> getVisibles() async {
    final data = await _personCompressorRepository.getVisibles();
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _personCompressorRepository.synchronize(lastSync);
  }
}
