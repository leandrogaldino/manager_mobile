import 'package:manager_mobile/repositories/productcode_repository.dart';

class ProductCodeService {
  final ProductCodeRepository _productCodeRepository;

  ProductCodeService({
    required ProductCodeRepository productCodeRepository,
  }) : _productCodeRepository = productCodeRepository;

  Future<void> synchronize(int lastSync) async {
    await _productCodeRepository.synchronize(lastSync);
  }
}
