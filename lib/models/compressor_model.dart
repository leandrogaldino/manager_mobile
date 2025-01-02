// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class CompressorModel {
  final int id;
  final int compressorId;
  final String compressorName;
  final DateTime lastUpdate;
  final PersonModel owner;
  final String serialNumber;
  final List<CoalescentModel> coalescents;

  CompressorModel({
    required this.id,
    required this.compressorId,
    required this.compressorName,
    required this.lastUpdate,
    required this.owner,
    required this.serialNumber,
    required this.coalescents,
  });

  CompressorModel copyWith({
    int? id,
    int? compressorId,
    String? compressorName,
    DateTime? lastUpdate,
    PersonModel? owner,
    String? serialNumber,
    List<CoalescentModel>? coalescents,
  }) {
    return CompressorModel(
      id: id ?? this.id,
      compressorId: compressorId ?? this.compressorId,
      compressorName: compressorName ?? this.compressorName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      owner: owner ?? this.owner,
      serialNumber: serialNumber ?? this.serialNumber,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'compressorId': compressorId,
      'compressorName': compressorName,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
      'owner': owner.toMap(),
      'serialNumber': serialNumber,
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
    };
  }

  factory CompressorModel.fromMap(Map<String, dynamic> map) {
    return CompressorModel(
      id: (map['id'] ?? 0) as int,
      compressorId: (map['compressorId'] ?? 0) as int,
      compressorName: (map['compressorName'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
      owner: PersonModel.fromMap(map['owner'] as Map<String, dynamic>),
      serialNumber: (map['serialNumber'] ?? '') as String,
      coalescents: List<CoalescentModel>.from(
        (map['coalescents'] as List<int>).map<CoalescentModel>(
          (x) => CoalescentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompressorModel.fromJson(String source) => CompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompressorModel(id: $id, compressorId: $compressorId, compressorName: $compressorName, lastUpdate: $lastUpdate, owner: $owner, serialNumber: $serialNumber, coalescents: $coalescents)';
  }

  @override
  bool operator ==(covariant CompressorModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.compressorId == compressorId && other.compressorName == compressorName && other.lastUpdate == lastUpdate && other.owner == owner && other.serialNumber == serialNumber && listEquals(other.coalescents, coalescents);
  }

  @override
  int get hashCode {
    return id.hashCode ^ compressorId.hashCode ^ compressorName.hashCode ^ lastUpdate.hashCode ^ owner.hashCode ^ serialNumber.hashCode ^ coalescents.hashCode;
  }
}
