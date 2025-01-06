import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:manager_mobile/models/coalescent_model.dart';

class CompressorModel {
  final int id;
  final int statusId;
  final int compressorId;
  final String compressorName;
  final DateTime lastUpdate;
  final String serialNumber;
  final List<CoalescentModel> coalescents;

  CompressorModel({
    required this.id,
    required this.statusId,
    required this.compressorId,
    required this.compressorName,
    required this.lastUpdate,
    required this.serialNumber,
    required this.coalescents,
  });

  CompressorModel copyWith({
    int? id,
    int? statusId,
    int? compressorId,
    String? compressorName,
    DateTime? lastUpdate,
    String? serialNumber,
    List<CoalescentModel>? coalescents,
  }) {
    return CompressorModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      compressorId: compressorId ?? this.compressorId,
      compressorName: compressorName ?? this.compressorName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      serialNumber: serialNumber ?? this.serialNumber,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  factory CompressorModel.fromMap(Map<String, dynamic> map) {
    return CompressorModel(
      id: (map['id'] ?? 0) as int,
      statusId: (map['statusid'] ?? 0) as int,
      compressorId: (map['compressorid'] ?? 0) as int,
      compressorName: (map['compressorname'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
      serialNumber: (map['serialnumber'] ?? '') as String,
      coalescents: List<CoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<CoalescentModel>(
          (x) => CoalescentModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'CompressorModel(id: $id, statusId: $statusId, compressorId: $compressorId, compressorName: $compressorName, lastUpdate: $lastUpdate, serialNumber: $serialNumber, coalescents: $coalescents)';
  }

  @override
  bool operator ==(covariant CompressorModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.statusId == statusId && other.compressorId == compressorId && other.compressorName == compressorName && other.lastUpdate == lastUpdate && other.serialNumber == serialNumber && listEquals(other.coalescents, coalescents);
  }

  @override
  int get hashCode {
    return id.hashCode ^ statusId.hashCode ^ compressorId.hashCode ^ compressorName.hashCode ^ lastUpdate.hashCode ^ serialNumber.hashCode ^ coalescents.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'statusid': statusId,
      'compressorid': compressorId,
      'compressorname': compressorName,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
      'serialnumber': serialNumber,
    };
  }

  String toJson() => json.encode(toMap());

  factory CompressorModel.fromJson(String source) => CompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
