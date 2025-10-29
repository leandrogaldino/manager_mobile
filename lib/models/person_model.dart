import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';

class PersonModel {
  final int id;
  final bool visible;
  final String document;
  final bool isCustomer;
  final bool isTechnician;
  final DateTime lastUpdate;
  final String shortName;
  final List<PersonCompressorModel> personCompressors;

  PersonModel({
    required this.id,
    required this.visible,
    required this.document,
    required this.isCustomer,
    required this.isTechnician,
    required this.lastUpdate,
    required this.shortName,
    required this.personCompressors,
  });

  PersonModel copyWith({
    int? id,
    bool? visible,
    String? document,
    bool? isCustomer,
    bool? isTechnician,
    DateTime? lastUpdate,
    String? shortName,
    List<PersonCompressorModel>? personCompressors,
  }) {
    return PersonModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      document: document ?? this.document,
      isCustomer: isCustomer ?? this.isCustomer,
      isTechnician: isTechnician ?? this.isTechnician,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      shortName: shortName ?? this.shortName,
      personCompressors: personCompressors ?? this.personCompressors,
    );
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] as int == 0 ? false : true,
      document: (map['document'] ?? '') as String,
      isCustomer: map['iscustomer'] == 0 ? false : true,
      isTechnician: map['istechnician'] == 0 ? false : true,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
      shortName: (map['shortname'] ?? '') as String,
      personCompressors: List<PersonCompressorModel>.from(
        (map['personcompressors'] as List<Map<String, dynamic>>).map<PersonCompressorModel>(
          (x) => PersonCompressorModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'PersonModel(id: $id, visible: $visible, document: $document, isCustomer: $isCustomer, isTechnician: $isTechnician, lastUpdate: $lastUpdate, shortName: $shortName, personCompressors: $personCompressors)';
  }

  @override
  bool operator ==(covariant PersonModel other) {
    if (identical(this, other)) return true;
    return other.id == id && other.visible == visible && other.document == document && other.isCustomer == isCustomer && other.isTechnician == isTechnician && other.lastUpdate == lastUpdate && other.shortName == shortName && listEquals(other.personCompressors, personCompressors);
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ document.hashCode ^ isCustomer.hashCode ^ isTechnician.hashCode ^ lastUpdate.hashCode ^ shortName.hashCode ^ personCompressors.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
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
