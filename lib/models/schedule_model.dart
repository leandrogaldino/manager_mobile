import 'dart:convert';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class ScheduleModel {
  final int id;
  final bool visible;
  final int userId;
  final DateTime creationDate;
  final DateTime visitDate;
  final CallTypes callType;
  final PersonModel customer;
  final PersonCompressorModel compressor;
  final String instructions;
  final DateTime lastUpdate;
  ScheduleModel({
    required this.id,
    required this.visible,
    required this.userId,
    required this.creationDate,
    required this.visitDate,
    required this.callType,
    required this.customer,
    required this.compressor,
    required this.instructions,
    required this.lastUpdate,
  });

  ScheduleModel copyWith({
    int? id,
    bool? visible,
    int? userId,
    DateTime? creationDate,
    DateTime? visitDate,
    CallTypes? callType,
    PersonModel? customer,
    PersonCompressorModel? compressor,
    String? instructions,
    DateTime? lastUpdate,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      userId: userId ?? this.userId,
      creationDate: creationDate ?? this.creationDate,
      visitDate: visitDate ?? this.visitDate,
      callType: callType ?? this.callType,
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
      'userid': userId,
      'creationdate': creationDate.millisecondsSinceEpoch,
      'visitdate': visitDate.millisecondsSinceEpoch,
      'calltype': callType.index,
      'customer': customer.toMap(),
      'compressor': compressor.toMap(),
      'instructions': instructions,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] as int == 0 ? false : true,
      userId: (map['userid'] ?? 0) as int,
      creationDate: DateTime.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
      visitDate: DateTime.fromMillisecondsSinceEpoch((map['visitdate'] ?? 0) as int),
      callType: CallTypes.values[map['calltypeid'] as int],
      customer: PersonModel.fromMap(map['customer'] as Map<String, dynamic>),
      compressor: PersonCompressorModel.fromMap(map['compressor'] as Map<String, dynamic>),
      instructions: (map['instructions'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) => ScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScheduleModel(id: $id, visible: $visible, userId: $userId, creationdate: $creationDate, visitDate: $visitDate, callType: ${callType.stringValue}, customer: $customer, compressor: $compressor, instructions: $instructions, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ScheduleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visible == visible &&
        other.userId == userId &&
        other.creationDate == creationDate &&
        other.visitDate == visitDate &&
        other.callType == callType &&
        other.customer == customer &&
        other.compressor == compressor &&
        other.instructions == instructions &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ userId.hashCode ^ creationDate.hashCode ^ visitDate.hashCode ^ callType.hashCode ^ customer.hashCode ^ compressor.hashCode ^ instructions.hashCode ^ lastUpdate.hashCode;
  }
}
