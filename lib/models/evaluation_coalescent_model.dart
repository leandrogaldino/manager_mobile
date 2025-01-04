import 'dart:convert';

import 'package:manager_mobile/models/coalescent_model.dart';

class EvaluationCoalescentModel {
  final int id;
  final CoalescentModel coalescent;
  final int nextChange;

  EvaluationCoalescentModel({required this.id, required this.coalescent, required this.nextChange});
}
