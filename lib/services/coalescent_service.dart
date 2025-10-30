import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';

class CoalescentService {
  final PersonCompressorCoalescentRepository _coalescentRepository;

  CoalescentService({required PersonCompressorCoalescentRepository coalescentRepository}) : _coalescentRepository = coalescentRepository;

  Future<void> synchronize(int lastSync) async {
    await _coalescentRepository.synchronize(lastSync);
  }
}
