import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manager_mobile/models/personcompressorcoalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/compressor_model.dart';

class PersonCompressorModel {
  final int id;
  final bool visible;
  final CompressorModel compressor;
  final DateTime lastUpdate;
  final String serialNumber;
  final String sector;
  final List<PersonCompressorCoalescentModel> coalescents;

  PersonCompressorModel({
    required this.id,
    required this.visible,
    required this.compressor,
    required this.lastUpdate,
    required this.serialNumber,
    required this.sector,
    required this.coalescents,
  });

  PersonCompressorModel copyWith({
    int? id,
    bool? visible,
    CompressorModel? compressor,
    DateTime? lastUpdate,
    String? serialNumber,
    String? sector,
    PersonModel? person,
    List<PersonCompressorCoalescentModel>? coalescents,
  }) {
    return PersonCompressorModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      compressor: compressor ?? this.compressor,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      serialNumber: serialNumber ?? this.serialNumber,
      sector: sector ?? this.sector,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  factory PersonCompressorModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] as int == 0 ? false : true,
      compressor: CompressorModel.fromMap(map['compressor']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
      serialNumber: (map['serialnumber'] ?? '') as String,
      sector: (map['sector'] ?? '') as String,
      coalescents: List<PersonCompressorCoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<PersonCompressorCoalescentModel>(
          (x) => PersonCompressorCoalescentModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'CompressorModel(id: $id, visible: $visible, compressor: $compressor, lastUpdate: $lastUpdate, serialNumber: $serialNumber, sector: $sector,  coalescents: $coalescents)';
  }

  @override
  bool operator ==(covariant PersonCompressorModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.compressor == compressor && other.lastUpdate == lastUpdate && other.serialNumber == serialNumber && other.sector == sector && listEquals(other.coalescents, coalescents);
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ compressor.hashCode ^ lastUpdate.hashCode ^ serialNumber.hashCode ^ sector.hashCode ^ coalescents.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
      'serialnumber': serialNumber,
      'sector': sector,
    };
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorModel.fromJson(String source) => PersonCompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
