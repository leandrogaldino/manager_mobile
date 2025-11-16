// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';

class VisitScheduleModel {
  final int id;
  final bool visible;
  final CallTypes callType;
  final DateTime creationDate;
  final DateTime scheduleDate;
  final DateTime? performedDate;
  final PersonModel technician;
  final PersonModel customer;
  final PersonCompressorModel compressor;
  final String instructions;
  final DateTime lastUpdate;

  VisitScheduleModel({
    required this.id,
    required this.visible,
    required this.callType,
    required this.creationDate,
    required this.scheduleDate,
    this.performedDate,
    required this.technician,
    required this.customer,
    required this.compressor,
    required this.instructions,
    required this.lastUpdate,
  });

  VisitScheduleModel copyWith({
    int? id,
    bool? visible,
    CallTypes? callType,
    DateTime? creationDate,
    DateTime? scheduleDate,
    DateTime? performedDate,
    PersonModel? technician,
    PersonModel? customer,
    PersonCompressorModel? compressor,
    String? instructions,
    DateTime? lastUpdate,
  }) {
    return VisitScheduleModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      callType: callType ?? this.callType,
      creationDate: creationDate ?? this.creationDate,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      performedDate: performedDate ?? this.performedDate,
      technician: technician ?? this.technician,
      customer: customer ?? this.customer,
      compressor: compressor ?? this.compressor,
      instructions: instructions ?? this.instructions,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'calltype': callType.index,
      'creationdate': creationDate.millisecondsSinceEpoch,
      'scheduledate': scheduleDate.millisecondsSinceEpoch,
      'performeddate': performedDate?.millisecondsSinceEpoch,
      'technician': technician.toMap(),
      'customer': customer.toMap(),
      'compressor': compressor.toMap(),
      'instructions': instructions,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory VisitScheduleModel.fromMap(Map<String, dynamic> map) {
    return VisitScheduleModel(
      id: (map['id'] ?? 0) as int,
      visible:  map['visible'] == 0 ? false : true,
      callType: CallTypes.values[map['calltypeid'] as int],
      creationDate: DateTime.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
      scheduleDate: DateTime.fromMillisecondsSinceEpoch((map['scheduleddate'] ?? 0) as int),
      performedDate: map['performedDate'] != null ? DateTime.fromMillisecondsSinceEpoch((map['performeddate'] ?? 0) as int) : null,
      technician: PersonModel.fromMap(map['technician']),
      customer: PersonModel.fromMap(map['customer']),
      compressor: PersonCompressorModel.fromMap(map['compressor'] ),
      instructions: (map['instructions'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitScheduleModel.fromJson(String source) => VisitScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VisitScheduleModel(id: $id, visible: $visible, callType: $callType, creationDate: $creationDate, scheduleDate: $scheduleDate, performedDate: $performedDate, technician: $technician, customer: $customer, compressor: $compressor, instructions: $instructions, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant VisitScheduleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visible == visible &&
        other.callType == callType &&
        other.creationDate == creationDate &&
        other.scheduleDate == scheduleDate &&
        other.performedDate == performedDate &&
        other.technician == technician &&
        other.customer == customer &&
        other.compressor == compressor &&
        other.instructions == instructions &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ callType.hashCode ^  creationDate.hashCode ^ scheduleDate.hashCode ^ performedDate.hashCode ^ technician.hashCode ^ customer.hashCode ^ compressor.hashCode ^ instructions.hashCode ^ lastUpdate.hashCode;
  }
}
