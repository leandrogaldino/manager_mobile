import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _productRepository;

  ProductService({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Future<List<PersonCompressorModel>> getVisibles() async {
    final data = await _productRepository.getVisibles();
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<void> synchronize(int lastSync) async {
    await _productRepository.synchronize(lastSync);
  }
}
