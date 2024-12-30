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
  final EvaluationModel evaluation;
  final String instructions;
  final DateTime lastUpdate;
  final CompressorModel compressor;

  ScheduleModel({required this.id, required this.statusId, required this.userId, required this.creation, required this.visitDate, required this.visitTypeId, required this.customer, required this.evaluation, required this.instructions, required this.lastUpdate, required this.compressor});
}
