import 'package:manager_mobile/repositories/compressor_unit_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class CompressorUnitService {
  final CompressorUnitRepository _compressorUnitRepository;
  final SyncEventBus _eventBus;

  CompressorUnitService({required CompressorUnitRepository compressorUnitRepository, required SyncEventBus eventBus})
      : _compressorUnitRepository = compressorUnitRepository,
        _eventBus = eventBus;

  Future<int> synchronize(int lastSync) {
    return _compressorUnitRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.compressorUnit(id),
        );
      },
    );
  }
}
