import 'package:manager_mobile/repositories/coalescent_repository.dart';

class CoalescentService {
  final CoalescentRepository _coalescentRepository;

  CoalescentService({required CoalescentRepository coalescentRepository}) : _coalescentRepository = coalescentRepository;

  Future<void> synchronize(int lastSync) async {
    await _coalescentRepository.synchronize(lastSync);
  }
}
