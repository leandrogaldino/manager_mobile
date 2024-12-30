abstract class RemoteDatabase {
  Future<List<Map<String, dynamic>>> get({required String collection, List<RemoteDatabaseFilter>? filters});
  Future<bool> updateField({required String collection, required String documentId, required String field, required dynamic value});
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
