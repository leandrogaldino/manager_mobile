// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_info_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class EvaluationModel {
  final String id;
  final String advice;
  final CompressorModel compressor;
  final PersonModel customer;
  final DateTime creationDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int horimeter;
  final int airFilter;
  final int oilFilter;
  final int separator;
  final int oil;
  final List<EvaluationCoalescentModel> coalescents;
  final List<EvaluationTechnicianModel> technicians;
  final List<EvaluationPhotoModel> photoPaths;
  final String responsible;
  final String signaturePath;
  final EvaluationInfoModel info;
  final DateTime lastUpdate;
  EvaluationModel({
    required this.id,
    required this.advice,
    required this.compressor,
    required this.customer,
    required this.creationDate,
    required this.startTime,
    required this.endTime,
    required this.horimeter,
    required this.airFilter,
    required this.oilFilter,
    required this.separator,
    required this.oil,
    required this.coalescents,
    required this.technicians,
    required this.photoPaths,
    required this.responsible,
    required this.signaturePath,
    required this.info,
    required this.lastUpdate,
  });

  EvaluationModel copyWith({
    String? id,
    String? advice,
    CompressorModel? compressor,
    PersonModel? customer,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? horimeter,
    int? airFilter,
    int? oilFilter,
    int? separator,
    int? oil,
    List<EvaluationCoalescentModel>? coalescents,
    List<EvaluationTechnicianModel>? technicians,
    List<EvaluationPhotoModel>? photoPaths,
    String? responsible,
    String? signaturePath,
    EvaluationInfoModel? info,
    DateTime? lastUpdate,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      advice: advice ?? this.advice,
      compressor: compressor ?? this.compressor,
      customer: customer ?? this.customer,
      creationDate: date ?? this.creationDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      horimeter: horimeter ?? this.horimeter,
      airFilter: airFilter ?? this.airFilter,
      oilFilter: oilFilter ?? this.oilFilter,
      separator: separator ?? this.separator,
      oil: oil ?? this.oil,
      coalescents: coalescents ?? this.coalescents,
      technicians: technicians ?? this.technicians,
      photoPaths: photoPaths ?? this.photoPaths,
      responsible: responsible ?? this.responsible,
      signaturePath: signaturePath ?? this.signaturePath,
      info: info ?? this.info,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: (map['id'] ?? '') as String,
      advice: (map['advice'] ?? '') as String,
      compressor: CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>),
      customer: PersonModel.fromMap(map['customer'] as Map<String, dynamic>),
      creationDate: DateTime.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
      startTime: TimeOfDay(hour: int.parse(map['starttime'].toString().split(':')[0]), minute: int.parse(map['starttime'].toString().split(':')[1])),
      endTime: TimeOfDay(hour: int.parse(map['endtime'].toString().split(':')[0]), minute: int.parse(map['endtime'].toString().split(':')[1])),
      horimeter: (map['horimeter'] ?? 0) as int,
      airFilter: (map['airfilter'] ?? 0) as int,
      oilFilter: (map['oilfilter'] ?? 0) as int,
      separator: (map['separator'] ?? 0) as int,
      oil: (map['oil'] ?? 0) as int,
      coalescents: List<EvaluationCoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<EvaluationCoalescentModel>(
          (x) => EvaluationCoalescentModel.fromMap(x),
        ),
      ),
      technicians: List<EvaluationTechnicianModel>.from(
        (map['technicians'] as List<Map<String, dynamic>>).map<EvaluationTechnicianModel>(
          (x) => EvaluationTechnicianModel.fromMap(x),
        ),
      ),
      photoPaths: List<EvaluationPhotoModel>.from(
        (map['photopaths'] as List<Map<String, dynamic>>).map<EvaluationPhotoModel>(
          (x) => EvaluationPhotoModel.fromMap(x),
        ),
      ),
      responsible: (map['responsible'] ?? '') as String,
      signaturePath: (map['signaturepath']),
      info: EvaluationInfoModel.fromMap(map['info'] as Map<String, dynamic>),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  @override
  String toString() {
    return 'EvaluationModel(id: $id, advice: $advice, compressor: $compressor, customer: $customer, creationdate: $creationDate, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oil: $oil, coalescents: $coalescents, technicians: $technicians, photoPaths: $photoPaths, responsible: $responsible, signaturePath: $signaturePath, info: $info, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant EvaluationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.advice == advice &&
        other.compressor == compressor &&
        other.customer == customer &&
        other.creationDate == creationDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.horimeter == horimeter &&
        other.airFilter == airFilter &&
        other.oilFilter == oilFilter &&
        other.separator == separator &&
        other.oil == oil &&
        listEquals(other.coalescents, coalescents) &&
        listEquals(other.technicians, technicians) &&
        listEquals(other.photoPaths, photoPaths) &&
        other.responsible == responsible &&
        other.signaturePath == signaturePath &&
        other.info == info &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        advice.hashCode ^
        compressor.hashCode ^
        customer.hashCode ^
        creationDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        horimeter.hashCode ^
        airFilter.hashCode ^
        oilFilter.hashCode ^
        separator.hashCode ^
        oil.hashCode ^
        coalescents.hashCode ^
        technicians.hashCode ^
        photoPaths.hashCode ^
        responsible.hashCode ^
        signaturePath.hashCode ^
        info.hashCode ^
        lastUpdate.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'advice': advice,
      'compressorid': compressor.id,
      'customerid': customer.id,
      'creationdate': creationDate.millisecondsSinceEpoch,
      'starttime': '${startTime.hour.toString()}:${startTime.minute.toString()}',
      'endtime': '${endTime.hour.toString()}:${endTime.minute.toString()}',
      'horimeter': horimeter,
      'parts': {
        'airfiler': airFilter,
        'oilFilter': oilFilter,
        'separator': separator,
        'oil': oil,
        'coalescents': coalescents.map((x) => x.toMap()).toList(),
      },
      'technicians': technicians.map((x) => x.toMap()).toList(),
      'photopaths': photoPaths,
      'responsible': responsible,
      'signaturepath': signaturePath,
      'info': info.toMap(),
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory EvaluationModel.fromJson(String source) => EvaluationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
