import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_info_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/oil_types.dart';

class EvaluationModel {
  String? id;
  String? advice;
  CompressorModel? compressor;
  PersonModel? customer;
  DateTime creationDate;
  TimeOfDay startTime;
  TimeOfDay? endTime;
  int? horimeter;
  OilTypes? oilType;
  int? airFilter;
  int? oilFilter;
  int? separator;
  int? oil;
  List<EvaluationCoalescentModel> coalescents;
  List<EvaluationTechnicianModel> technicians;
  List<EvaluationPhotoModel> photoPaths;
  String? responsible;
  String? signaturePath;
  EvaluationInfoModel? info;
  DateTime? lastUpdate;
  EvaluationModel({
    this.id,
    this.advice,
    this.compressor,
    this.customer,
    required this.creationDate,
    required this.startTime,
    this.endTime,
    this.horimeter,
    this.oilType,
    this.airFilter,
    this.oilFilter,
    this.separator,
    this.oil,
    required this.coalescents,
    required this.technicians,
    required this.photoPaths,
    this.responsible,
    this.signaturePath,
    this.info,
    this.lastUpdate,
  });

  factory EvaluationModel.fromSource({ScheduleModel? schedule}) {
    List<EvaluationCoalescentModel> coalescents = [];
    if (schedule != null) {
      for (var coalescent in schedule.compressor.coalescents) {
        coalescents.add(EvaluationCoalescentModel(id: 0, coalescent: coalescent, nextChange: 0));
      }
    }

    return EvaluationModel(
        id: null,
        advice: null,
        customer: schedule?.customer,
        compressor: schedule?.compressor,
        creationDate: DateTime.now(),
        startTime: TimeOfDay.now(),
        endTime: null,
        horimeter: null,
        oilType: OilTypes.semiSynthetic,
        airFilter: null,
        oilFilter: null,
        separator: null,
        oil: null,
        coalescents: coalescents,
        technicians: [],
        photoPaths: [],
        responsible: null,
        signaturePath: null,
        info: null,
        lastUpdate: null);
  }

  EvaluationModel copyWith({
    String? id,
    String? advice,
    CompressorModel? compressor,
    PersonModel? customer,
    DateTime? creationDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? horimeter,
    OilTypes? oilType,
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
      creationDate: creationDate ?? this.creationDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      horimeter: horimeter ?? this.horimeter,
      oilType: oilType ?? this.oilType,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'advice': advice,
      'compressor': compressor?.toMap(),
      'customer': customer?.toMap(),
      'creationDate': creationDate.millisecondsSinceEpoch,
      'startTime': '${startTime.hour.toString()}:${startTime.minute.toString()}',
      'endTime': '${endTime?.hour.toString()}:${endTime?.minute.toString()}',
      'horimeter': horimeter,
      'oilType': oilType?.name,
      'airFilter': airFilter,
      'oilFilter': oilFilter,
      'separator': separator,
      'oil': oil,
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
      'technicians': technicians.map((x) => x.toMap()).toList(),
      'photoPaths': photoPaths.map((x) => x.toMap()).toList(),
      'responsible': responsible,
      'signaturePath': signaturePath,
      'info': info?.toMap(),
      'lastUpdate': lastUpdate?.millisecondsSinceEpoch,
    };
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: map['id'] != null ? map['id'] as String : null,
      advice: map['advice'] != null ? map['advice'] as String : null,
      compressor: map['compressor'] != null ? CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>) : null,
      customer: map['customer'] != null ? PersonModel.fromMap(map['customer'] as Map<String, dynamic>) : null,
      creationDate: DateTime.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
      startTime: TimeOfDay(hour: int.parse(map['starttime'].toString().split(':')[0]), minute: int.parse(map['starttime'].toString().split(':')[1])),
      endTime: TimeOfDay(hour: int.parse(map['endtime'].toString().split(':')[0]), minute: int.parse(map['endtime'].toString().split(':')[1])),
      horimeter: map['horimeter'] != null ? map['horimeter'] as int : null,
      oilType: OilTypes.values[map['oiltypeid'] as int],
      airFilter: map['airfilter'] != null ? map['airfilter'] as int : null,
      oilFilter: map['oilfilter'] != null ? map['oilfilter'] as int : null,
      separator: map['separator'] != null ? map['separator'] as int : null,
      oil: map['oil'] != null ? map['oil'] as int : null,
      coalescents: List<EvaluationCoalescentModel>.from(
        (map['coalescents'] as List<Map<String, Object?>>).map<EvaluationCoalescentModel>(
          (x) => EvaluationCoalescentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      technicians: List<EvaluationTechnicianModel>.from(
        (map['technicians'] as List<Map<String, Object?>>).map<EvaluationTechnicianModel>(
          (x) => EvaluationTechnicianModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      photoPaths: List<EvaluationPhotoModel>.from(
        (map['photopaths'] as List<Map<String, Object?>>).map<EvaluationPhotoModel>(
          (x) => EvaluationPhotoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      responsible: map['responsible'] != null ? map['responsible'] as String : null,
      signaturePath: map['signaturepath'] != null ? map['signaturepath'] as String : null,
      info: map['info'] != null ? EvaluationInfoModel.fromMap(map['info'] as Map<String, dynamic>) : null,
      lastUpdate: map['lastupdate'] != null ? DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationModel.fromJson(String source) => EvaluationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EvaluationModel(id: $id, advice: $advice, compressor: $compressor, customer: $customer, creationDate: $creationDate, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, oilType: ${oilType!.name}, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oil: $oil, coalescents: $coalescents, technicians: $technicians, photoPaths: $photoPaths, responsible: $responsible, signaturePath: $signaturePath, info: $info, lastUpdate: $lastUpdate)';
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
        other.oilType == oilType &&
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
        oilType.hashCode ^
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
}
