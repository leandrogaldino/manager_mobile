import 'package:manager_mobile/models/syncronize_result_model.dart';

abstract class Repository {
  Future<SyncronizeResultModel> syncronize();
  Future<Map<String, dynamic>> getById(int id);
  Future<List<Map<String, dynamic>>> getByLastUpdate(DateTime lastUpdate);
  Future<List<Map<String, dynamic>>> getAll();
  Future<int> save(Map<String, dynamic> data);
  Future<int> delete(int id);
}
