import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class CompressorService {
  final CompressorRepository _compressorRepository;
  final SyncEventBus _eventBus;

  CompressorService({required CompressorRepository compressorRepository, required SyncEventBus eventBus})
      : _compressorRepository = compressorRepository,
        _eventBus = eventBus;

  Future<int> synchronize(int lastSync) {
    return _compressorRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.compressor(id),
        );
      },
    );
  }
}
