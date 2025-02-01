// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager_mobile/models/person_model.dart';

class EvaluationTechnicianModel {
  final int id;
  final bool isMain;
  final PersonModel technician;

  EvaluationTechnicianModel({
    required this.id,
    required this.isMain,
    required this.technician,
  });

  EvaluationTechnicianModel copyWith({
    int? id,
    bool? isMain,
    PersonModel? technician,
  }) {
    return EvaluationTechnicianModel(
      id: id ?? this.id,
      isMain: isMain ?? this.isMain,
      technician: technician ?? this.technician,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ismain': isMain == false ? 0 : 1,
      'personid': technician.id,
    };
  }

  factory EvaluationTechnicianModel.fromMap(Map<String, dynamic> map) {
    return EvaluationTechnicianModel(
      id: (map['id'] ?? 0) as int,
      isMain: map['ismain'] == 0 ? false : true,
      technician: PersonModel.fromMap(map['technician'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationTechnicianModel.fromJson(String source) => EvaluationTechnicianModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationTechnicianModel(id: $id, isMain: $isMain, technician: $technician)';

  @override
  bool operator ==(covariant EvaluationTechnicianModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.technician == technician && other.isMain == isMain;
  }

  @override
  int get hashCode => id.hashCode ^ isMain.hashCode ^ technician.hashCode;
}
