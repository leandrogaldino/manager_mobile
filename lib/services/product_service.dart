import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _productRepository;

  ProductService({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

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
    return await _productRepository.synchronize(lastSync);
  }
}
