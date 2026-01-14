import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _serviceRepository;

  ServiceService({
    required ServiceRepository serviceRepository,
  }) : _serviceRepository = serviceRepository;

  Future<List<ServiceModel>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    List<int>? remove,
  }) async {
    final data = await _serviceRepository.searchVisibles(
      offset: offset,
      limit: limit,
      search: search,
      remove: remove,
    );
    return data.map((item) => ServiceModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _serviceRepository.synchronize(lastSync);
  }
}
