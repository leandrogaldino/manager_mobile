// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager_mobile/models/coalescent_model.dart';

class EvaluationCoalescentModel {
  final int id;
  final CoalescentModel coalescent;
  final DateTime? nextChange;

  EvaluationCoalescentModel({
    required this.id,
    required this.coalescent,
    this.nextChange,
  });

  EvaluationCoalescentModel copyWith({
    int? id,
    CoalescentModel? coalescent,
    DateTime? nextChange,
  }) {
    return EvaluationCoalescentModel(
      id: id ?? this.id,
      coalescent: coalescent ?? this.coalescent,
      nextChange: nextChange ?? this.nextChange,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationCoalescentModel.fromJson(String source) => EvaluationCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationCoalescentModel(id: $id, coalescent: $coalescent, nextChange: $nextChange)';

  @override
  bool operator ==(covariant EvaluationCoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.coalescent == coalescent && other.nextChange == nextChange;
  }

  @override
  int get hashCode => id.hashCode ^ coalescent.hashCode ^ nextChange.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'coalescent': coalescent.toMap(),
      'nextchange': nextChange?.millisecondsSinceEpoch,
    };
  }

  factory EvaluationCoalescentModel.fromMap(Map<String, dynamic> map) {
    return EvaluationCoalescentModel(
      id: (map['id'] ?? 0) as int,
      coalescent: CoalescentModel.fromMap(map['coalescent'] as Map<String, dynamic>),
      nextChange: map['nextchange'] != null ? DateTime.fromMillisecondsSinceEpoch((map['nextchange'] ?? 0) as int) : null,
    );
  }
}
