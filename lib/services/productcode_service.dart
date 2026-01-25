import 'package:manager_mobile/repositories/productcode_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class ProductCodeService {
  final ProductCodeRepository _productCodeRepository;
  final SyncEventBus _eventBus;

  ProductCodeService({required ProductCodeRepository productCodeRepository, required SyncEventBus eventBus})
      : _productCodeRepository = productCodeRepository,
        _eventBus = eventBus;

  Future<int> synchronize(int lastSync) async {
    return _productCodeRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.productCode(id),
        );
      },
    );
  }
}
