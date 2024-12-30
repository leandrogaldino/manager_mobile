abstract class Service<T> {
  Future<int> syncronize();
  Future<List<T>> getByLastUpdate(DateTime lastUpdate);
  Future<T> getById(int id);
  Future<List<T>> getAll();
  Future<int> save(T model);
  Future<int> delete(int id);
}
