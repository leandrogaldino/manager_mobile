import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';

class PersonCompressorService {
  final PersonCompressorRepository _personCompressorRepository;

  PersonCompressorService({required PersonCompressorRepository personCompressorRepository}) : _personCompressorRepository = personCompressorRepository;

  Future<List<PersonCompressorModel>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
  }) async {
    final data = await _personCompressorRepository.searchVisibles(
      offset: offset,
      limit: limit,
      search: search,
    );
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _personCompressorRepository.synchronize(lastSync);
  }
}
