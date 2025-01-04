abstract class ServiceParent<T> {
  Future<List<T>> getByParentId(int parentId);
}
