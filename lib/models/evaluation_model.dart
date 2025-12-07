import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/models/evaluation_replaced_product_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';

class EvaluationModel {
  String? id;
  bool visible;
  int? importedId;
  int? visitscheduleid;
  bool existsInCloud;
  bool needProposal;
  CallTypes callType;
  String? unitName;
  int? temperature;
  double? pressure;
  PersonModel? customer;
  PersonCompressorModel? compressor;
  DateTime? creationDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? horimeter;
  OilTypes oilType;
  int? airFilter;
  int? oilFilter;
  int? separator;
  int? oil;
  List<EvaluationCoalescentModel> coalescents;
  List<EvaluationReplacedProductModel> replacedProducts;
  List<EvaluationPerformedServiceModel> performedServices;
  List<EvaluationTechnicianModel> technicians;
  List<EvaluationPhotoModel> photos;
  String? responsible;
  String? signaturePath;
  String? advice;
  DateTime? lastUpdate;
  EvaluationModel({
    this.id,
    this.visible = true,
    this.importedId,
    this.visitscheduleid,
    this.existsInCloud = false,
    this.needProposal = false,
    this.callType = CallTypes.none,
    this.unitName,
    this.temperature,
    this.pressure,
    this.customer,
    this.compressor,
    DateTime? creationDate,
    TimeOfDay? startTime,
    this.endTime,
    this.horimeter,
    this.oilType = OilTypes.none,
    this.airFilter,
    this.oilFilter,
    this.separator,
    this.oil,
    required this.coalescents,
    required this.replacedProducts,
    required this.performedServices,
    required this.technicians,
    required this.photos,
    this.responsible,
    this.signaturePath,
    this.advice,
    this.lastUpdate,
  })  : creationDate = creationDate ?? DateTimeHelper.now(),
        startTime =  startTime ?? TimeOfDay.now();

  factory EvaluationModel.fromScheduleOrNew({VisitScheduleModel? schedule}) {
    List<EvaluationCoalescentModel> coalescents = [];
    if (schedule != null) {
      for (var coalescent in schedule.compressor.coalescents) {
        coalescents.add(EvaluationCoalescentModel(coalescent: coalescent));
      }
    }
    return EvaluationModel(
      id: null,
      visible: true,
      importedId: null,
      visitscheduleid: schedule?.id,
      existsInCloud: false,
      needProposal: false,
      callType: schedule != null ? schedule.callType : CallTypes.none,
      unitName: null,
      temperature: null,
      pressure: null,
      customer: schedule?.customer,
      compressor: schedule?.compressor,
      creationDate: DateTimeHelper.now(),
      startTime: TimeOfDay.now(),
      endTime: null,
      horimeter: null,
      oilType: OilTypes.none,
      airFilter: null,
      oilFilter: null,
      separator: null,
      oil: null,
      coalescents: coalescents,
      replacedProducts: [],
      performedServices: [],
      technicians: [],
      photos: [],
      responsible: null,
      signaturePath: null,
      advice: null,
      lastUpdate: null,
    );
  }

  EvaluationModel copyWith({
    String? id,
    bool? visible,
    int? importedId,
    int? visitscheduleid,
    bool? existsInCloud,
    bool? needProposal,
    CallTypes? callType,
    String? unitName,
    int? temperature,
    double? pressure,
    PersonModel? customer,
    PersonCompressorModel? compressor,
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
    List<EvaluationReplacedProductModel>? replacedProducts,
    List<EvaluationPerformedServiceModel>? performedServices,
    List<EvaluationTechnicianModel>? technicians,
    List<EvaluationPhotoModel>? photos,
    String? responsible,
    String? signaturePath,
    String? advice,
    DateTime? lastUpdate,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      visitscheduleid: visitscheduleid ?? this.visitscheduleid,
      importedId: importedId ?? this.importedId,
      existsInCloud: existsInCloud ?? this.existsInCloud,
      needProposal: needProposal ?? this.needProposal,
      callType: callType ?? this.callType,
      unitName: unitName ?? this.unitName,
      temperature: temperature ?? this.temperature,
      pressure: pressure ?? this.pressure,
      customer: customer ?? this.customer,
      compressor: compressor ?? this.compressor,
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
      replacedProducts: replacedProducts ?? this.replacedProducts,
      performedServices: performedServices ?? this.performedServices,
      technicians: technicians ?? this.technicians,
      photos: photos ?? this.photos,
      responsible: responsible ?? this.responsible,
      signaturePath: signaturePath ?? this.signaturePath,
      advice: advice ?? this.advice,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible ? 1 : 0,
      'importedid': importedId,
      'visitscheduleid': visitscheduleid,
      'existsincloud': existsInCloud ? 1 : 0,
      'needproposal': needProposal ? 1 : 0,
      'calltypeid': callType.index,
      'unitname': unitName,
      'temperature': temperature,
      'pressure': pressure,
      'customerid': customer?.id,
      'compressorid': compressor?.id,
      'creationdate': creationDate?.millisecondsSinceEpoch,
      'starttime': '${startTime?.hour.toString().padLeft(2, '0')}:${startTime?.minute.toString().padLeft(2, '0')}',
      'endtime': '${endTime?.hour.toString().padLeft(2, '0')}:${endTime?.minute.toString().padLeft(2, '0')}',
      'horimeter': horimeter,
      'oiltypeid': oilType.index,
      'airfilter': airFilter,
      'oilfilter': oilFilter,
      'separator': separator,
      'oil': oil,
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
      'replacedproducts': replacedProducts.map((x) => x.toMap()).toList(),
      'performedservices': performedServices.map((x) => x.toMap()).toList(),
      'technicians': technicians.map((x) => x.toMap()).toList(),
      'photos': photos.map((x) => x.toMap()).toList(),
      'responsible': responsible,
      'signaturepath': signaturePath,
      'advice': advice,
      'lastupdate': lastUpdate?.millisecondsSinceEpoch,
    };
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: map['id'] != null ? map['id'] as String : null,
      visible: map['visible'] as int == 0 ? false : true,
      importedId: map['importedid'] != null ? map['importedid'] as int : null,
      visitscheduleid: map['visitscheduleid'] != null ? map['visitscheduleid'] as int : null,
      existsInCloud: map['existsincloud'] == 0 ? false : true,
      needProposal: map['needproposal'] == 0 ? false : true,
      callType: CallTypes.values[map['calltypeid'] as int],
      unitName: map['unitname'] != null ? map['unitname'] as String : null,
      temperature: map['temperature'] != null ? map['temperature'] as int : null,
      pressure: map['pressure'] != null ? map['pressure'] as double : null,
      advice: map['advice'] != null ? map['advice'] as String : null,
      customer: map['customer'] != null ? PersonModel.fromMap(map['customer']) : null,
      compressor: map['compressor'] != null ? PersonCompressorModel.fromMap(map['compressor']) : null,
      creationDate: DateTimeHelper.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
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
      replacedProducts: List<EvaluationReplacedProductModel>.from(
        (map['replacedproducts'] as List<Map<String, Object?>>).map<EvaluationReplacedProductModel>(
          (x) => EvaluationReplacedProductModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      performedServices: List<EvaluationPerformedServiceModel>.from(
        (map['performedservices'] as List<Map<String, Object?>>).map<EvaluationPerformedServiceModel>(
          (x) => EvaluationPerformedServiceModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      technicians: List<EvaluationTechnicianModel>.from(
        (map['technicians'] as List<Map<String, Object?>>).map<EvaluationTechnicianModel>(
          (x) => EvaluationTechnicianModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      photos: List<EvaluationPhotoModel>.from(
        (map['photos'] as List<Map<String, Object?>>).map<EvaluationPhotoModel>(
          (x) => EvaluationPhotoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      responsible: map['responsible'] != null ? map['responsible'] as String : null,
      signaturePath: map['signaturepath'] != null ? map['signaturepath'] as String : null,
      lastUpdate: map['lastupdate'] != null ? DateTimeHelper.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationModel.fromJson(String source) => EvaluationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EvaluationModel(id: $id, visible: $visible, importedId: $importedId, visitscheduleid: $visitscheduleid, existsInCloud: $existsInCloud, needProposal: $needProposal, callType: $callType, unitname: $unitName, temperature: $temperature, pressure: $pressure, customer: $customer, compressor: $compressor, creationDate: $creationDate, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, oilType: $oilType, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oil: $oil, coalescents: $coalescents, replacedproducts: $replacedProducts, performedservices: $performedServices, technicians: $technicians, photos: $photos, responsible: $responsible, signaturePath: $signaturePath, advice: $advice, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant EvaluationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visible == visible &&
        other.importedId == importedId &&
        other.visitscheduleid == visitscheduleid &&
        other.existsInCloud == existsInCloud &&
        other.needProposal == needProposal &&
        other.callType == callType &&
        other.unitName == unitName &&
        other.temperature == temperature &&
        other.pressure == pressure &&
        other.customer == customer &&
        other.compressor == compressor &&
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
        listEquals(other.replacedProducts, replacedProducts) &&
        listEquals(other.performedServices, performedServices) &&
        listEquals(other.technicians, technicians) &&
        listEquals(other.photos, photos) &&
        other.responsible == responsible &&
        other.signaturePath == signaturePath &&
        other.advice == advice &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        visible.hashCode ^
        importedId.hashCode ^
        visitscheduleid.hashCode ^
        existsInCloud.hashCode ^
        needProposal.hashCode ^
        callType.hashCode ^
        unitName.hashCode ^
        temperature.hashCode ^
        pressure.hashCode ^
        customer.hashCode ^
        compressor.hashCode ^
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
        replacedProducts.hashCode ^
        performedServices.hashCode ^
        technicians.hashCode ^
        photos.hashCode ^
        responsible.hashCode ^
        signaturePath.hashCode ^
        advice.hashCode ^
        lastUpdate.hashCode;
  }


}
