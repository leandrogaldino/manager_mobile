abstract class Readable<T> {
  Future<T> getById(int id);
  Future<List<T>> getByLastUpdate(DateTime lastUpdate);
  Future<List<T>> getAll();
}
