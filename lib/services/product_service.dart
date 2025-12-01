import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _productRepository;

  ProductService({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Future<List<ProductModel>> getVisibles() async {
    final data = await _productRepository.getVisibles();
    //TODO: Codes
    return data.map((item) => ProductModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _productRepository.synchronize(lastSync);
  }
}
