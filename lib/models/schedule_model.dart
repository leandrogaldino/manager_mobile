import 'dart:convert';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class ScheduleModel {
  final int id;
  final int statusId;
  final int userId;
  final DateTime creationDate;
  final DateTime visitDate;
  final int visitTypeId;
  final PersonModel customer;
  final CompressorModel compressor;
  final String instructions;
  final DateTime lastUpdate;
  ScheduleModel({
    required this.id,
    required this.statusId,
    required this.userId,
    required this.creationDate,
    required this.visitDate,
    required this.visitTypeId,
    required this.customer,
    required this.compressor,
    required this.instructions,
    required this.lastUpdate,
  });

  ScheduleModel copyWith({
    int? id,
    int? statusId,
    int? userId,
    DateTime? creationDate,
    DateTime? visitDate,
    int? visitTypeId,
    PersonModel? customer,
    CompressorModel? compressor,
    String? instructions,
    DateTime? lastUpdate,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      userId: userId ?? this.userId,
      creationDate: creationDate ?? this.creationDate,
      visitDate: visitDate ?? this.visitDate,
      visitTypeId: visitTypeId ?? this.visitTypeId,
      customer: customer ?? this.customer,
      compressor: compressor ?? this.compressor,
      instructions: instructions ?? this.instructions,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'statusid': statusId,
      'userid': userId,
      'creationdate': creationDate.millisecondsSinceEpoch,
      'visitdate': visitDate.millisecondsSinceEpoch,
      'visittypeid': visitTypeId,
      'customer': customer.toMap(),
      'compressor': compressor.toMap(),
      'instructions': instructions,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: (map['id'] ?? 0) as int,
      statusId: (map['statusid'] ?? 0) as int,
      userId: (map['userid'] ?? 0) as int,
      creationDate: DateTime.fromMillisecondsSinceEpoch((map['creationdate'] ?? 0) as int),
      visitDate: DateTime.fromMillisecondsSinceEpoch((map['visitdate'] ?? 0) as int),
      visitTypeId: (map['visittypeid'] ?? 0) as int,
      customer: PersonModel.fromMap(map['customer'] as Map<String, dynamic>),
      compressor: CompressorModel.fromMap(map['compressor'] as Map<String, dynamic>),
      instructions: (map['instructions'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) => ScheduleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String get visitTypeString {
    switch (visitTypeId) {
      case 0:
        return 'Levantamento';
      case 1:
        return 'Preventiva';
      case 2:
        return 'Chamado';
      case 3:
        return 'Contrato';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'ScheduleModel(id: $id, statusId: $statusId, userId: $userId, creationdate: $creationDate, visitDate: $visitDate, visitTypeId: $visitTypeId, customer: $customer, compressor: $compressor, instructions: $instructions, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ScheduleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.statusId == statusId &&
        other.userId == userId &&
        other.creationDate == creationDate &&
        other.visitDate == visitDate &&
        other.visitTypeId == visitTypeId &&
        other.customer == customer &&
        other.compressor == compressor &&
        other.instructions == instructions &&
        other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ statusId.hashCode ^ userId.hashCode ^ creationDate.hashCode ^ visitDate.hashCode ^ visitTypeId.hashCode ^ customer.hashCode ^ compressor.hashCode ^ instructions.hashCode ^ lastUpdate.hashCode;
  }
}
