abstract class Readable<T> {
  Future<T> getById(dynamic id);
  Future<List<T>> getAll();
}
