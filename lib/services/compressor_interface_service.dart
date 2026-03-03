import 'package:manager_mobile/repositories/compressor_interface_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class CompressorInterfaceService {
  final CompressorInterfaceRepository _compressorInterfaceRepository;
  final SyncEventBus _eventBus;

  CompressorInterfaceService({required CompressorInterfaceRepository compressorInterfaceRepository, required SyncEventBus eventBus})
      : _compressorInterfaceRepository = compressorInterfaceRepository,
        _eventBus = eventBus;

  Future<int> synchronize(int lastSync) {
    return _compressorInterfaceRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.compressorInterface(id),
        );
      },
    );
  }
}
