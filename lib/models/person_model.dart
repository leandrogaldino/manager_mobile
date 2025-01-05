// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:manager_mobile/models/compressor_model.dart';

class PersonModel {
  final int id;
  final int statusId;
  final String document;
  final bool isCustomer;
  final bool isTechnician;
  final int lastUpdate;
  final String shortName;
  final List<CompressorModel> compressors;
  PersonModel({
    required this.id,
    required this.statusId,
    required this.document,
    required this.isCustomer,
    required this.isTechnician,
    required this.lastUpdate,
    required this.shortName,
    required this.compressors,
  });

  PersonModel copyWith({
    int? id,
    int? statusId,
    String? document,
    bool? isCustomer,
    bool? isTechnician,
    int? lastUpdate,
    String? shortName,
    List<CompressorModel>? compressors,
  }) {
    return PersonModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      document: document ?? this.document,
      isCustomer: isCustomer ?? this.isCustomer,
      isTechnician: isTechnician ?? this.isTechnician,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      shortName: shortName ?? this.shortName,
      compressors: compressors ?? this.compressors,
    );
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: (map['id'] ?? 0) as int,
      statusId: (map['statusid'] ?? 0) as int,
      document: (map['document'] ?? '') as String,
      isCustomer: map['iscustomer'] == 0 ? false : true,
      isTechnician: map['istechnician'] == 0 ? false : true,
      lastUpdate: (map['lastupdate'] ?? 0) as int,
      shortName: (map['shortname'] ?? '') as String,
      compressors: List<CompressorModel>.from(
        (map['compressors'] as List<Map<String, dynamic>>).map<CompressorModel>(
          (x) => CompressorModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'PersonModel(id: $id, statusId: $statusId, document: $document, isCustomer: $isCustomer, isTechnician: $isTechnician, lastUpdate: $lastUpdate, shortName: $shortName, compressors: $compressors)';
  }

  @override
  bool operator ==(covariant PersonModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.statusId == statusId && other.document == document && other.isCustomer == isCustomer && other.isTechnician == isTechnician && other.lastUpdate == lastUpdate && other.shortName == shortName && listEquals(other.compressors, compressors);
  }

  @override
  int get hashCode {
    return id.hashCode ^ statusId.hashCode ^ document.hashCode ^ isCustomer.hashCode ^ isTechnician.hashCode ^ lastUpdate.hashCode ^ shortName.hashCode ^ compressors.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'statusid': statusId,
      'document': document,
      'iscustomer': isCustomer == false ? 0 : 1,
      'istechnician': isTechnician == false ? 0 : 1,
      'lastupdate': lastUpdate,
      'shortname': shortName,
    };
  }

  String toJson() => json.encode(toMap());

  factory PersonModel.fromJson(String source) => PersonModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
