// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonModel {
  final String document;
  final int id;
  final bool isCustomer;
  final bool isTechnician;
  final int lastUpdate;
  final String shortName;

  PersonModel({
    required this.document,
    required this.id,
    required this.isCustomer,
    required this.isTechnician,
    required this.lastUpdate,
    required this.shortName,
  });

  PersonModel copyWith({
    String? document,
    int? id,
    bool? isCustomer,
    bool? isTechnician,
    int? lastUpdate,
    bool? needChangePassword,
    String? userId,
    String? shortName,
  }) {
    return PersonModel(
      document: document ?? this.document,
      id: id ?? this.id,
      isCustomer: isCustomer ?? this.isCustomer,
      isTechnician: isTechnician ?? this.isTechnician,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      shortName: shortName ?? this.shortName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'document': document,
      'id': id,
      'iscustomer': isCustomer,
      'istechnician': isTechnician,
      'lastupdate': lastUpdate,
      'shortname': shortName,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      document: (map['document'] ?? '') as String,
      id: (map['id'] ?? 0) as int,
      isCustomer: (map['iscustomer'] == null || map['iscustomer'] == 0 ? false : true),
      isTechnician: (map['istechnician'] == null || map['istechnician'] == 0 ? false : true),
      lastUpdate: (map['lastupdate'] ?? 0) as int,
      shortName: (map['shortname'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) => PersonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonModel(document: $document, id: $id, isCustomer: $isCustomer, isTechnician: $isTechnician, lastUpdate: $lastUpdate, shortName: $shortName)';
  }

  @override
  bool operator ==(covariant PersonModel other) {
    if (identical(this, other)) return true;

    return other.document == document && other.id == id && other.isCustomer == isCustomer && other.isTechnician == isTechnician && other.lastUpdate == lastUpdate && other.shortName == shortName;
  }

  @override
  int get hashCode {
    return document.hashCode ^ id.hashCode ^ isCustomer.hashCode ^ isTechnician.hashCode ^ lastUpdate.hashCode ^ shortName.hashCode;
  }
}
