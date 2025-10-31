import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manager_mobile/models/personcompressorcoalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/compressor_model.dart';

class PersonCompressorModel {
  final int id;
  final bool visible;
  final PersonModel person;
  final CompressorModel compressor;
  final DateTime lastUpdate;
  final String serialNumber;
  final String sector;
  final String patrimony;
  final List<PersonCompressorCoalescentModel> coalescents;

  PersonCompressorModel({
    required this.id,
    required this.visible,
    required this.person,
    required this.compressor,
    required this.lastUpdate,
    required this.serialNumber,
    required this.sector,
    required this.patrimony,
    required this.coalescents,
  });

  PersonCompressorModel copyWith({
    int? id,
    bool? visible,
    PersonModel? person,
    CompressorModel? compressor,
    DateTime? lastUpdate,
    String? serialNumber,
    String? sector,
    String? patrimony,
    List<PersonCompressorCoalescentModel>? coalescents,
  }) {
    return PersonCompressorModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      person: person ?? this.person,
      compressor: compressor ?? this.compressor,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      serialNumber: serialNumber ?? this.serialNumber,
      sector: sector ?? this.sector,
      patrimony: patrimony ?? this.patrimony,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  factory PersonCompressorModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] == 0 ? false : true,
      person: PersonModel.fromMap(map['person']),
      compressor: CompressorModel.fromMap(map['compressor']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
      serialNumber: (map['serialnumber'] ?? '') as String,
      sector: (map['sector'] ?? '') as String,
      patrimony: (map['patrimony'] ?? '') as String,
      coalescents: List<PersonCompressorCoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<PersonCompressorCoalescentModel>(
          (x) => PersonCompressorCoalescentModel.fromMap(x),
        ),
      ),
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'person': person.toMap(),
      'compressor': compressor.toMap(),
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
      'serialnumber': serialNumber,
      'sector': sector,
      'patrimony': patrimony,
      'coalescents': coalescents.map((x) => x.toMap),
    };
  }

  @override
  String toString() {
    return 'CompressorModel(id: $id, visible: $visible, person: $person, compressor: $compressor, lastUpdate: $lastUpdate, serialNumber: $serialNumber, sector: $sector, patrimony: $patrimony, coalescents: $coalescents)';
  }

  @override
  bool operator ==(covariant PersonCompressorModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.visible == visible &&
        other.person == person &&
        other.compressor == compressor &&
        other.lastUpdate == lastUpdate &&
        other.serialNumber == serialNumber &&
        other.sector == sector &&
        other.patrimony == patrimony &&
        listEquals(
          other.coalescents,
          coalescents,
        );
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ person.hashCode ^ compressor.hashCode ^ lastUpdate.hashCode ^ serialNumber.hashCode ^ sector.hashCode ^ patrimony.hashCode ^ coalescents.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorModel.fromJson(String source) => PersonCompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
