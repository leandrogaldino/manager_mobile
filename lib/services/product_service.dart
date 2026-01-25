import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/repositories/product_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class ProductService {
  final ProductRepository _productRepository;
  final SyncEventBus _eventBus;

  ProductService({required ProductRepository productRepository, required SyncEventBus eventBus})
      : _productRepository = productRepository,
        _eventBus = eventBus;

  Future<List<ProductModel>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    List<int>? remove,
  }) async {
    final data = await _productRepository.searchVisibles(
      offset: offset,
      limit: limit,
      search: search,
      remove: remove,
    );
    return data.map((item) => ProductModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return _productRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.product(id),
        );
      },
    );
  }
}
