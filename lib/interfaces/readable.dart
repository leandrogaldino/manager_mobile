abstract class Readable<T> {
  Future<T> getById(dynamic id);
  Future<List<T>> getByLastUpdate(DateTime lastUpdate);
  Future<List<T>> getAll();
}
