import 'dart:convert';

class PersonModel {
  final int id;
  final int statusId;
  final String document;
  final bool isCustomer;
  final bool isTechnician;
  final DateTime lastUpdate;
  final String shortName;
  PersonModel({
    required this.id,
    required this.statusId,
    required this.document,
    required this.isCustomer,
    required this.isTechnician,
    required this.lastUpdate,
    required this.shortName,
  });

  PersonModel copyWith({
    int? id,
    int? statusId,
    String? document,
    bool? isCustomer,
    bool? isTechnician,
    DateTime? lastUpdate,
    String? shortName,
  }) {
    return PersonModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      document: document ?? this.document,
      isCustomer: isCustomer ?? this.isCustomer,
      isTechnician: isTechnician ?? this.isTechnician,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      shortName: shortName ?? this.shortName,
    );
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: (map['id'] ?? 0) as int,
      statusId: (map['statusid'] ?? 0) as int,
      document: (map['document'] ?? '') as String,
      isCustomer: map['iscustomer'] == 0 ? false : true,
      isTechnician: map['istechnician'] == 0 ? false : true,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
      shortName: (map['shortname'] ?? '') as String,
    );
  }

  @override
  String toString() {
    return 'PersonModel(id: $id, statusId: $statusId, document: $document, isCustomer: $isCustomer, isTechnician: $isTechnician, lastUpdate: $lastUpdate, shortName: $shortName)';
  }

  @override
  bool operator ==(covariant PersonModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.statusId == statusId && other.document == document && other.isCustomer == isCustomer && other.isTechnician == isTechnician && other.lastUpdate == lastUpdate && other.shortName == shortName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ statusId.hashCode ^ document.hashCode ^ isCustomer.hashCode ^ isTechnician.hashCode ^ lastUpdate.hashCode ^ shortName.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'statusid': statusId,
      'document': document,
      'iscustomer': isCustomer == false ? 0 : 1,
      'istechnician': isTechnician == false ? 0 : 1,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
      'shortname': shortName,
    };
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) => PersonModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
