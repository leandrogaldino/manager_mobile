abstract class RemoteDatabase {
  Future<List<Map<String, dynamic>>> get({required String collection, List<RemoteDatabaseFilter>? filters});
  Future<void> set({required String collection, required Map<String, dynamic> data, String? id, bool merge = false});
  Future<void> delete({required String collection, required List<RemoteDatabaseFilter> filters});
  Future<void> update({required String collection, required String id, required Map<String, dynamic> data});
}

class RemoteDatabaseFilter {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  RemoteDatabaseFilter({
    required this.field,
    required this.operator,
    required this.value,
  });
}

enum FilterOperator {
  isEqualTo,
  isNotEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  isNull,
  whereIn,
  whereNotIn,
}
