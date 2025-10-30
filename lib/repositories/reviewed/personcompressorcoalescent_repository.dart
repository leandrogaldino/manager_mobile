import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/reviewed/product_repository.dart';

class PersonCompressorCoalescentRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final ProductRepository _productRepository;

  PersonCompressorCoalescentRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required ProductRepository productRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _productRepository = productRepository;

  Future<Map<String, Object?>> getById(int id) async {
    try {
      final Map<String, Object?> personCompressorCoalescent = await _localDatabase.query('personcompressorcoalescent', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      final productId = personCompressorCoalescent['productid'];
      final product = await _productRepository.getById(productId);
      personCompressorCoalescent['product'] = product;
      personCompressorCoalescent.remove('productid');
      return personCompressorCoalescent;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PER001', 'Erro ao obter os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getByPersonCompressorId(int personCompressorId) async {
    try {
      final personCompressorCoalescents = await _localDatabase.query('personcompressorcoalescent', where: 'personcompressorid = ?', whereArgs: [personCompressorId]);
      for (var personCompressorCoalescent in personCompressorCoalescents) {
        final productId = personCompressorCoalescent['productid'];
        final product = await _productRepository.getById(productId);
        personCompressorCoalescent['product'] = product;
      }
      return personCompressorCoalescents;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA001', 'Erro ao obter os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      final remoteResult = await _remoteDatabase.get(collection: 'personcompressorcoalescents', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
      for (var data in remoteResult) {
        final bool exists = await _localDatabase.isSaved('personcompressorcoalescent', id: data['id']);
        data.remove('documentid');
        if (exists) {
          await _localDatabase.update('personcompressorcoalescent', data, where: 'id = ?', whereArgs: [data['id']]);
        } else {
          await _localDatabase.insert('personcompressorcoalescent', data);
        }
      }
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('COA002', 'Erro ao sincronizar os dados: $e');
    }
  }
}
