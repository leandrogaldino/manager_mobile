import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _serviceRepository;

  ServiceService({
    required ServiceRepository serviceRepository,
  }) : _serviceRepository = serviceRepository;

  Future<List<ServiceModel>> getVisibles() async {
    final data = await _serviceRepository.getVisibles();
    return data.map((item) => ServiceModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _serviceRepository.synchronize(lastSync);
  }
}
