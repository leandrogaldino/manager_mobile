import 'package:flutter/foundation.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class EvaluationModel {
  final String id;
  final String advice;
  final CompressorModel compressor;
  final PersonModel customer;
  final DateTime date;
  final Duration startTime;
  final Duration endTime;
  final int horimeter;
  final int airFilter;
  final int oilFilter;
  final int separator;
  final int oil;
  final List<EvaluationCoalescentModel> coalescents;
  final List<PersonModel> technicians;
  final List<String> photoPaths;
  final String responsible;
  final String signaturePath;
  EvaluationModel({
    required this.id,
    required this.advice,
    required this.compressor,
    required this.customer,
    required this.date,
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
  });

  EvaluationModel copyWith({
    String? id,
    String? advice,
    CompressorModel? compressor,
    PersonModel? customer,
    DateTime? date,
    Duration? startTime,
    Duration? endTime,
    int? horimeter,
    int? airFilter,
    int? oilFilter,
    int? separator,
    int? oil,
    List<EvaluationCoalescentModel>? coalescents,
    List<PersonModel>? technicians,
    List<String>? photoPaths,
    String? responsible,
    String? signaturePath,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      advice: advice ?? this.advice,
      compressor: compressor ?? this.compressor,
      customer: customer ?? this.customer,
      date: date ?? this.date,
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
    );
  }

  factory EvaluationModel.fromMap(Map<String, dynamic> map) {
    return EvaluationModel(
      id: (map['id'] ?? '') as String,
      advice: (map['advice'] ?? '') as String,
      compressor: CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>),
      customer: PersonModel.fromMap(map['customer'] as Map<String, dynamic>),
      date: DateTime.fromMillisecondsSinceEpoch((map['date'] ?? 0) as int),
      startTime: map['startTime'],
      endTime: map['endTime'],
      horimeter: (map['horimeter'] ?? 0) as int,
      airFilter: (map['airFilter'] ?? 0) as int,
      oilFilter: (map['oilFilter'] ?? 0) as int,
      separator: (map['separator'] ?? 0) as int,
      oil: (map['oil'] ?? 0) as int,
      coalescents: List<EvaluationCoalescentModel>.from(
        (map['coalescents'] as List<Map<String, dynamic>>).map<EvaluationCoalescentModel>(
          (x) => EvaluationCoalescentModel.fromMap(x),
        ),
      ),
      technicians: List<PersonModel>.from(
        (map['technicians'] as List<int>).map<PersonModel>(
          (x) => PersonModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      photoPaths: List<String>.from(
        (map['photos'] as List<String>),
      ),
      responsible: (map['responsible'] ?? '') as String,
      signaturePath: (map['signature']),
    );
  }

  @override
  String toString() {
    return 'EvaluationModel(id: $id, advice: $advice, compressor: $compressor, customer: $customer, date: $date, startTime: $startTime, endTime: $endTime, horimeter: $horimeter, airFilter: $airFilter, oilFilter: $oilFilter, separator: $separator, oil: $oil, responsible: $responsible)';
  }

  @override
  bool operator ==(covariant EvaluationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.advice == advice &&
        other.compressor == compressor &&
        other.customer == customer &&
        other.date == date &&
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
        other.signaturePath == signaturePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        advice.hashCode ^
        compressor.hashCode ^
        customer.hashCode ^
        date.hashCode ^
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
        signaturePath.hashCode;
  }
}
