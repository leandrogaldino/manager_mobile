import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class PersonCompressorCoalescentService {
  final PersonCompressorCoalescentRepository _coalescentRepository;
  final SyncEventBus _eventBus;

  PersonCompressorCoalescentService({required PersonCompressorCoalescentRepository coalescentRepository, required SyncEventBus eventBus})
      : _coalescentRepository = coalescentRepository,
        _eventBus = eventBus;

  Future<int> synchronize(int lastSync) async {
    return _coalescentRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.personCompressorCoalescent(id),
        );
      },
    );
  }
}
