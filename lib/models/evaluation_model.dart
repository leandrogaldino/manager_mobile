import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';

class EvaluationModel {
  String? id; // O ID DA AVALIAÇÃO NO ESCOPO DA NUVEM E CELULAR DO TECNICO (UM TEXTO ALEATORIO GERADO PELO SISTEMA NA HORA DE SALVAR)
  int? importedId; //O ID RETORNADO PRA NUVEM E PARA O CELULAR, ESSE ID É O MESMO ID DO GERENCIADOR QUANDO A GENTE SALVAR A AVALIAÇÃO
  bool existsInCloud; //UMA FLAG PARA SINALIZAR SE A AVALIAÇÃO JÁ FOI ENVIADA PRA NUVEM OU SE ESTA APENAS NO CELULAR DE QUEM A FEZ
  bool needProposal; //UMA FLAG PARA SINALIZAR SE A AVALIAÇÃO NECESSITA DE PROPOSTA
  CallTypes callType; //UMA FLAG PARA SINALIZAR QUAL E O TIPO DESSA AVALIAÇÃO: PREVENTIVA, CORRETIVA, CONTRATO, LEVANTAMENTO
  PersonModel? customer; //O CLIENTE
  CompressorModel? compressor; //O COMPRESSOR DO CLIENTE
  DateTime? creationDate; //A DATA DE CRIAÇÃO DA AVALIAÇÃO
  TimeOfDay? startTime; //A HORA DE INICIO DA AVALIAÇÃO
  TimeOfDay? endTime; //A HORA DE FIM DA AVALIAÇÃO
  int? horimeter; //O HORIMETRO DO COMPRESSOR
  OilTypes? oilType; //O TIPO DE OLEO QUE O COMPRESSOR ESTA USANDO
  int? airFilter; //QUANDO FALTA PRA VENDER O FILTRO DE AR
  int? oilFilter; //QUANDO FALTA PRA VENDER O FILTRO DE OLEO
  int? separator; //QUANDO FALTA PRA VENDER O SEPARADOR
  int? oil; //QUANDO FALTA PRA VENDER O OLEO
  List<EvaluationCoalescentModel> coalescents; //OS COALESCENTES CADASTRADOS NO COMPRESSOR ACIMA
  List<EvaluationTechnicianModel> technicians; //OS TECNICOS QUE PARTICIPARAM DESSA AVALIAÇÃO/SERVICO
  List<EvaluationPhotoModel> photos; //AS FOTOS DO COMPRESSOR ACIMA SE NECESSARIO
  String? responsible; //A PESSOA QUE ACOMPANHOU A AVALIAÇÃO/SERVICO
  String? signaturePath; //O CAMINHO PARA A IMAGEM DA ASSINATURA DO RESPONSAVEL
  String? advice; //O PARECER TECNICO
  DateTime? lastUpdate; //A ULTIMA VEZ QUE HOUVE ALTERACAO NA AVALIACAO
  EvaluationModel({
    this.id,
    this.importedId,
    this.existsInCloud = false,
    this.needProposal = false,
    this.callType = CallTypes.none,
    this.customer,
    this.compressor,
    DateTime? creationDate,
    TimeOfDay? startTime,
    this.endTime,
    this.horimeter,
    this.oilType,
    this.airFilter,
    this.oilFilter,
    this.separator,
    this.oil,
    required this.coalescents,
    required this.technicians,
    required this.photos,
    this.responsible,
    this.signaturePath,
    this.advice,
    this.lastUpdate,
  })  : creationDate = creationDate ?? DateTime.now(),
        startTime = startTime ?? TimeOfDay.now();

  factory EvaluationModel.fromScheduleOrNew({ScheduleModel? schedule}) {
    List<EvaluationCoalescentModel> coalescents = [];
    if (schedule != null) {
      for (var coalescent in schedule.compressor.coalescents) {
        coalescents.add(EvaluationCoalescentModel(coalescent: coalescent));
      }
    }
    return EvaluationModel(
      id: null,
      importedId: null,
      existsInCloud: false,
      needProposal: false,
      callType: schedule != null ? schedule.callType : CallTypes.none,
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
      photos: [],
      responsible: null,
      signaturePath: null,
      advice: null,
      lastUpdate: null,
    );
  }

  EvaluationModel copyWith({
    String? id,
    int? importedId,
    bool? existsInCloud,
    bool? needProposal,
    CallTypes? callType,
    PersonModel? customer,
    CompressorModel? compressor,
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
    List<EvaluationPhotoModel>? photos,
    String? responsible,
    String? signaturePath,
    String? advice,
    DateTime? lastUpdate,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      importedId: importedId ?? this.importedId,
      existsInCloud: existsInCloud ?? this.existsInCloud,
      needProposal: needProposal ?? this.needProposal,
      callType: callType ?? this.callType,
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
      'importedid': importedId,
      'existsincloud': existsInCloud,
      'needproposal': needProposal,
      'calltypeid': callType.index,
      'compressorid': compressor?.id,
      'creationdate': creationDate?.millisecondsSinceEpoch,
      'starttime': '${startTime?.hour.toString()}:${startTime?.minute.toString()}',
      'endtime': '${endTime?.hour.toString()}:${endTime?.minute.toString()}',
      'horimeter': horimeter,
      'oiltypeid': oilType?.index,
      'airfilter': airFilter,
      'oilfilter': oilFilter,
      'separator': separator,
      'oil': oil,
      'coalescents': coalescents.map((x) => x.toMap()).toList(),
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
      importedId: map['importedid'] != null ? map['importedid'] as int : null,
      existsInCloud: map['existsincloud'] == 0 ? false : true,
      needProposal: map['needproposal'] == 0 ? false : true,
      callType: CallTypes.values[map['calltypeid'] as int],
      advice: map['advice'] != null ? map['advice'] as String : null,
      customer: map['customer'] != null ? PersonModel.fromMap(map['customer'] as Map<String, dynamic>) : null,
      compressor: map['compressor'] != null ? CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>) : null,
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
      photos: List<EvaluationPhotoModel>.from(
        (map['photos'] as List<Map<String, Object?>>).map<EvaluationPhotoModel>(
          (x) => EvaluationPhotoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      responsible: map['responsible'] != null ? map['responsible'] as String : null,
      signaturePath: map['signaturepath'] != null ? map['signaturepath'] as String : null,
      lastUpdate: map['lastupdate'] != null ? DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationModel.fromJson(String source) => EvaluationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EvaluationModel(id: $id, importedId: $importedId, existsInCloud: $existsInCloud, needProposal: $needProposal, callType: $callType, customer: $customer, compressor: $compressor, creationDate: $creationDate, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, oilType: $oilType, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oil: $oil, coalescents: $coalescents, technicians: $technicians, photos: $photos, responsible: $responsible, signaturePath: $signaturePath, advice: $advice, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant EvaluationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.importedId == importedId &&
        other.existsInCloud == existsInCloud &&
        other.needProposal == needProposal &&
        other.callType == callType &&
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
        importedId.hashCode ^
        existsInCloud.hashCode ^
        needProposal.hashCode ^
        callType.hashCode ^
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
        technicians.hashCode ^
        photos.hashCode ^
        responsible.hashCode ^
        signaturePath.hashCode ^
        advice.hashCode ^
        lastUpdate.hashCode;
  }
}
