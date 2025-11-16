import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';

class ProductCodeRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;

  ProductCodeRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase;

  Future<List<Map<String, Object?>>> getByProductId(int productId) async {
    try {
      final productCodes = await _localDatabase.query('productcode', where: 'productid = ?', whereArgs: [productId]);
      return productCodes;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PCO001', 'Erro ao obter os dados: $e');
    }
  }

   Future<int> synchronize(int lastSync) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTime.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'productcodes',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('productcode', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('productcode', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('productcode', data);
          }
          count += 1;
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'productcodes',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: startTime)],
        );
        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('PCO002', 'Erro ao sincronizar os dados: $e');
    }
  }
}
