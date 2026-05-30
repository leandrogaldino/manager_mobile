import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/compressor_interface_model.dart';
import 'package:manager_mobile/models/compressor_unit_model.dart';
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
  final CompressorInterfaceModel interface;
  final CompressorUnitModel unit;
  final OilTypes oilType;
  final int airFilterCapacity;
  final int oilFilterCapacity;
  final int separatorCapacity;
  final int oilCapacity;
  final int? greasingCapacity;
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
    required this.interface,
    required this.unit,
    required this.oilType,
    required this.airFilterCapacity,
    required this.oilFilterCapacity,
    required this.separatorCapacity,
    required this.oilCapacity,
    this.greasingCapacity,
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
    CompressorInterfaceModel? interface,
    CompressorUnitModel? unit,
    OilTypes? oilType,
    int? airFilterCapacity,
    int? oilFilterCapacity,
    int? separatorCapacity,
    int? oilCapacity,
    int? greasingCapacity,
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
      interface: interface ?? this.interface,
      unit: unit ?? this.unit,
      oilType: oilType ?? this.oilType,
      airFilterCapacity: airFilterCapacity ?? this.airFilterCapacity,
      oilFilterCapacity: oilFilterCapacity ?? this.oilFilterCapacity,
      separatorCapacity: separatorCapacity ?? this.separatorCapacity,
      oilCapacity: oilCapacity ?? this.oilCapacity,
      greasingCapacity: greasingCapacity ?? this.greasingCapacity,
      coalescents: coalescents ?? this.coalescents,
    );
  }

  factory PersonCompressorModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] == 0 ? false : true,
      person: PersonModel.fromMap(map['person']),
      compressor: CompressorModel.fromMap(map['compressor']),
      lastUpdate: DateTimeHelper.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
      serialNumber: (map['serialnumber'] ?? '') as String,
      sector: (map['sector'] ?? '') as String,
      patrimony: (map['patrimony'] ?? '') as String,
      interface: CompressorInterfaceModel.fromMap(map['interface']),
      unit: CompressorUnitModel.fromMap(map['unit']),
      oilType: OilTypes.values[map['oiltypeid'] as int],
      airFilterCapacity: (map['airfiltercapacity'] ?? 0) as int,
      oilFilterCapacity: (map['oilfiltercapacity'] ?? 0) as int,
      separatorCapacity: (map['separatorcapacity'] ?? 0) as int,
      oilCapacity: (map['oilcapacity'] ?? 0) as int,
      greasingCapacity: map['greasingcapacity'] != null ? map['greasingcapacity'] as int : null,
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
      'interface': interface.toMap(),
      'unit': unit.toMap(),
      'oiltypeid': oilType.index,
      'airfiltercapacity': airFilterCapacity,
      'oilfiltercapacity': oilFilterCapacity,
      'separatorcapacity': separatorCapacity,
      'greasingcapacity': greasingCapacity,
      'coalescents': coalescents.map((x) => x.toMap),
    };
  }

  @override
  String toString() {
    return 'CompressorModel(id: $id, visible: $visible, person: $person, compressor: $compressor, lastUpdate: $lastUpdate, serialNumber: $serialNumber, sector: $sector, patrimony: $patrimony, interface: $interface, unit: $unit, oilType: $oilType, airFilterCapacity: $airFilterCapacity, oilFilterCapacity: $oilFilterCapacity, separatorCapacity: $separatorCapacity, greasingCapacity: $greasingCapacity, coalescents: $coalescents)';
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
        other.interface == interface &&
        other.unit == unit &&
        other.oilType == oilType &&
        other.airFilterCapacity == airFilterCapacity &&
        other.oilFilterCapacity == oilFilterCapacity &&
        other.separatorCapacity == separatorCapacity &&
        other.greasingCapacity == greasingCapacity &&
        listEquals(
          other.coalescents,
          coalescents,
        );
  }

  @override
  int get hashCode {
    return id.hashCode ^
        visible.hashCode ^
        person.hashCode ^
        compressor.hashCode ^
        lastUpdate.hashCode ^
        serialNumber.hashCode ^
        sector.hashCode ^
        patrimony.hashCode ^
        interface.hashCode ^
        unit.hashCode ^
        oilType.hashCode ^
        airFilterCapacity.hashCode ^
        oilFilterCapacity.hashCode ^
        separatorCapacity.hashCode ^
        oilCapacity.hashCode ^
        greasingCapacity.hashCode ^
        coalescents.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorModel.fromJson(String source) => PersonCompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
