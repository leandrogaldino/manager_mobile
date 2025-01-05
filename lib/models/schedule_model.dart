import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';

class ScheduleModel {
  final int id;
  final int statusId;
  final int userId;
  final DateTime creation;
  final DateTime visitDate;
  final int visitTypeId;
  final PersonModel customer;
  final CompressorModel compressor;
  final EvaluationModel? evaluation;
  final String instructions;
  final DateTime lastUpdate;
  ScheduleModel({
    required this.id,
    required this.statusId,
    required this.userId,
    required this.creation,
    required this.visitDate,
    required this.visitTypeId,
    required this.customer,
    required this.compressor,
    this.evaluation,
    required this.instructions,
    required this.lastUpdate,
  });

  ScheduleModel copyWith({
    int? id,
    int? statusId,
    int? userId,
    DateTime? creation,
    DateTime? visitDate,
    int? visitTypeId,
    PersonModel? customer,
    CompressorModel? compressor,
    EvaluationModel? evaluation,
    String? instructions,
    DateTime? lastUpdate,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      userId: userId ?? this.userId,
      creation: creation ?? this.creation,
      visitDate: visitDate ?? this.visitDate,
      visitTypeId: visitTypeId ?? this.visitTypeId,
      customer: customer ?? this.customer,
      compressor: compressor ?? this.compressor,
      evaluation: evaluation ?? this.evaluation,
      instructions: instructions ?? this.instructions,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
