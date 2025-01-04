import 'package:manager_mobile/models/syncronize_result_model.dart';

abstract class Repository {
  Future<SyncronizeResultModel> syncronize();
  Future<Map<String, Object?>> getById(int id);
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate);
  Future<List<Map<String, Object?>>> getAll();
  Future<int> save(Map<String, Object?> data);
  Future<int> delete(int id);
}

abstract class Readable<T> {
  Future<T> getById(int id);
  Future<List<T>> getByLastUpdate(DateTime lastUpdate);
  Future<List<T>> getAll();
}

abstract class Writable {
  Future<int> save(Map<String, Object?> data);
}

abstract class Deletable {
  Future<int> delete(int id);
}

abstract class Childable {}
