import 'package:manager_mobile/repositories/productcode_repository.dart';

class ProductCodeService {
  final ProductCodeRepository _productCodeRepository;

  ProductCodeService({
    required ProductCodeRepository productCodeRepository,
  }) : _productCodeRepository = productCodeRepository;

  Future<int> synchronize(int lastSync) async {
    return await _productCodeRepository.synchronize(lastSync);
  }
}
