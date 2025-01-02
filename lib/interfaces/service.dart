import 'package:manager_mobile/models/syncronize_result_model.dart';

abstract class Service<T> {
  Future<SyncronizeResultModel> syncronize();
  Future<List<T>> getByLastUpdate(DateTime lastUpdate);
  Future<T> getById(int id);
  Future<List<T>> getAll();
  Future<int> save(T model);
  Future<int> delete(int id);
}
