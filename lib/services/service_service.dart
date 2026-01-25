import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/repositories/service_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class ServiceService {
  final ServiceRepository _serviceRepository;
  final SyncEventBus _eventBus;

  ServiceService({required ServiceRepository serviceRepository, required SyncEventBus eventBus})
      : _serviceRepository = serviceRepository,
        _eventBus = eventBus;

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
   return _serviceRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.service(id),
        );
      },
    );
  }
}
