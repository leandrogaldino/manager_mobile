import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _serviceRepository;

  ServiceService({
    required ServiceRepository serviceRepository,
  }) : _serviceRepository = serviceRepository;

  Future<List<PersonCompressorModel>> getVisibles() async {
    final data = await _serviceRepository.getVisibles();
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<void> synchronize(int lastSync) async {
    await _serviceRepository.synchronize(lastSync);
  }
}
