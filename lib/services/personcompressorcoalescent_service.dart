import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';

class PersonCompressorCoalescentService {
  final PersonCompressorCoalescentRepository _coalescentRepository;

  PersonCompressorCoalescentService({
    required PersonCompressorCoalescentRepository coalescentRepository,
  }) : _coalescentRepository = coalescentRepository;

  Future<int> synchronize(int lastSync) async {
    return await _coalescentRepository.synchronize(lastSync);
  }
}
