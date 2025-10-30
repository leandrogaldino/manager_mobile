import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';

class PersonCompressorCoalescentService {
  final PersonCompressorCoalescentRepository _coalescentRepository;

  PersonCompressorCoalescentService({required PersonCompressorCoalescentRepository coalescentRepository}) : _coalescentRepository = coalescentRepository;

  Future<void> synchronize(int lastSync) async {
    await _coalescentRepository.synchronize(lastSync);
  }
}
