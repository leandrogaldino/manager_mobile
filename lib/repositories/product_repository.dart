import 'dart:developer';

import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/productcode_repository.dart';

class ProductRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final ProductCodeRepository _productCodeRepository;

  ProductRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required ProductCodeRepository productCodeRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _productCodeRepository = productCodeRepository;

  Future<Map<String, Object?>> getById(int id) async {
    try {
      final Map<String, Object?> product = await _localDatabase.query('product', where: 'id = ?', whereArgs: [id]).then((list) {
        if (list.isEmpty) return {};
        return list[0];
      });
      var codes = await _productCodeRepository.getByProductId(id);
      product['codes'] = codes;
      return product;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PRO001';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    List<int>? remove,
  }) async {
    try {
      String where = 'p.visible = ?';
      List<Object?> whereArgs = [1];

      if (search != null && search.trim().isNotEmpty) {
        where += ' AND (p.name LIKE ? OR pc.code LIKE ?)';
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
      }

      if (remove != null && remove.isNotEmpty) {
        final placeholders = List.filled(remove.length, '?').join(',');
        where += ' AND p.id NOT IN ($placeholders)';
        whereArgs.addAll(remove);
      }

      whereArgs.addAll([limit, offset]);
      
      var products = await _localDatabase.rawQuery('''
        SELECT p.*
        FROM product p
        JOIN productcode pc ON p.id = pc.productid
        WHERE $where
        ORDER BY pc.code ASC
        LIMIT ? OFFSET ?;
        ''', whereArgs);

      for (var product in products) {
        var codes = await _productCodeRepository.getByProductId(product['id'] as int);
        product['codes'] = codes;
      }
      return products;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PRO002';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(int lastSync) async {
    int count = 0;
    try {
      bool hasMore = true;
      while (hasMore) {
        final int startTime = DateTimeHelper.now().millisecondsSinceEpoch;
        final remoteResult = await _remoteDatabase.get(
          collection: 'products',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)],
        );
        if (remoteResult.isEmpty) {
          hasMore = false;
          break;
        }
        for (var data in remoteResult) {
          final bool exists = await _localDatabase.isSaved('product', id: data['id']);
          data.remove('documentid');
          if (exists) {
            await _localDatabase.update('product', data, where: 'id = ?', whereArgs: [data['id']]);
          } else {
            await _localDatabase.insert('product', data);
          }
          count += 1;
        }
        lastSync = remoteResult.map((r) => r['lastupdate'] as int).reduce((a, b) => a > b ? a : b);
        final newer = await _remoteDatabase.get(
          collection: 'products',
          filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: startTime)],
        );
        hasMore = newer.isNotEmpty;
      }
      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'PRO003';
      String message = 'Erro ao sincronizar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }
}
