import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class CompressorModel {
  final int id;
  final bool visible;
  final int compressorId;
  final String compressorName;
  final DateTime lastUpdate;
  final String serialNumber;
  final String sector;
  final PersonModel owner;
  final List<CoalescentModel> coalescents;

  CompressorModel({
    required this.id,
    required this.visible,
    required this.compressorId,
    required this.compressorName,
    required this.lastUpdate,
    required this.serialNumber,
    required this.sector,
    required this.owner,
    required this.coalescents,
  });

  CompressorModel copyWith({
    int? id,
    bool? visible,
    int? compressorId,
    String? compressorName,
    DateTime? lastUpdate,
    String? serialNumber,
    String? sector,
    PersonModel? owner,
    List<CoalescentModel>? coalescents,
  }) {
    return CompressorModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      compressorId: compressorId ?? this.compressorId,
      compressorName: compressorName ?? this.compressorName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      serialNumber: serialNumber ?? this.serialNumber,
      sector: sector ?? this.sector,
      owner: owner ?? this.owner,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  factory CompressorModel.fromMap(Map<String, dynamic> map) {
    return CompressorModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] as int == 0 ? false : true,
      compressorId: (map['compressorid'] ?? 0) as int,
      compressorName: (map['compressorname'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
      serialNumber: (map['serialnumber'] ?? '') as String,
      sector: (map['sector'] ?? '') as String,
      owner: PersonModel.fromMap(map['owner']),
      coalescents: List<CoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<CoalescentModel>(
          (x) => CoalescentModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'CompressorModel(id: $id, visible: $visible, compressorId: $compressorId, compressorName: $compressorName, lastUpdate: $lastUpdate, serialNumber: $serialNumber, sector: $sector, coalescents: $coalescents)';
  }

  @override
  bool operator ==(covariant CompressorModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visible == visible &&
        other.compressorId == compressorId &&
        other.compressorName == compressorName &&
        other.lastUpdate == lastUpdate &&
        other.serialNumber == serialNumber &&
        other.sector == sector &&
        other.owner == owner &&
        listEquals(other.coalescents, coalescents);
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ compressorId.hashCode ^ compressorName.hashCode ^ lastUpdate.hashCode ^ serialNumber.hashCode ^ sector.hashCode ^ owner.hashCode ^ coalescents.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'compressorid': compressorId,
      'compressorname': compressorName,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
      'serialnumber': serialNumber,
      'sector': sector,
    };
  }

  String toJson() => json.encode(toMap());

  factory CompressorModel.fromJson(String source) => CompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
