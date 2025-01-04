import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';

class FirestoreDatabase implements RemoteDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> get({required String collection, List<RemoteDatabaseFilter>? filters}) async {
    try {
      Query query = _db.collection(collection);
      query = _proccessFilters(query, filters);
      query.limit(1000);
      final snapshot = await query.get();
      List<Map<String, dynamic>> result = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'documentid': doc.id,
          ...data,
        };
      }).toList();
      return result;
    } catch (e) {
      throw RemoteDatabaseException('Ocorreu um erro ao consultar o registro na núvem: $e');
    }
  }

  Query _proccessFilters(Query query, List<RemoteDatabaseFilter>? filters) {
    if (filters != null) {
      for (var filter in filters) {
        switch (filter.operator) {
          case FilterOperator.isEqualTo:
            query = query.where(filter.field, isEqualTo: filter.value);
            break;
          case FilterOperator.isNotEqualTo:
            query = query.where(filter.field, isNotEqualTo: filter.value);
            break;
          case FilterOperator.isGreaterThan:
            query = query.where(filter.field, isGreaterThan: filter.value);
            break;
          case FilterOperator.isGreaterThanOrEqualTo:
            query = query.where(filter.field, isGreaterThanOrEqualTo: filter.value);
            break;
          case FilterOperator.isLessThan:
            query = query.where(filter.field, isLessThan: filter.value);
            break;
          case FilterOperator.isLessThanOrEqualTo:
            query = query.where(filter.field, isLessThanOrEqualTo: filter.value);
            break;
          case FilterOperator.arrayContains:
            query = query.where(filter.field, arrayContains: filter.value);
            break;
          case FilterOperator.arrayContainsAny:
            query = query.where(filter.field, arrayContainsAny: filter.value);
            break;
          case FilterOperator.isNull:
            query = query.where(filter.field, isNull: filter.value);
            break;
          case FilterOperator.whereIn:
            query = query.where(filter.field, whereIn: filter.value);
            break;
          case FilterOperator.whereNotIn:
            query = query.where(filter.field, whereNotIn: filter.value);
            break;
        }
      }
    }
    return query;
  }

  @override
  Future<bool> updateField({required String collection, required String documentId, required String field, required value}) async {
    try {
      await _db.collection(collection).doc(documentId).update({field: value});
      return true;
    } catch (e) {
      throw RemoteDatabaseException('Ocorreu um erro ao atualizar o registro na núvem: $e');
    }
  }
}
