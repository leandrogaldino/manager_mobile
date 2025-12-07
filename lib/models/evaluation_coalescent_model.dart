import 'dart:convert';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/personcompressorcoalescent_model.dart';

class EvaluationCoalescentModel {
  final int? id;
  final PersonCompressorCoalescentModel coalescent;
  final DateTime? nextChange;

  EvaluationCoalescentModel({
    this.id,
    required this.coalescent,
    this.nextChange,
  });

  EvaluationCoalescentModel copyWith({
    int? id,
    PersonCompressorCoalescentModel? coalescent,
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
      'coalescentid': coalescent.id,
      'nextchange': nextChange?.millisecondsSinceEpoch,
    };
  }

  factory EvaluationCoalescentModel.fromMap(Map<String, dynamic> map) {
    return EvaluationCoalescentModel(
      id: map['id'] != null ? map['id'] as int : null,
      coalescent: PersonCompressorCoalescentModel.fromMap(map['coalescent'] as Map<String, dynamic>),
      nextChange: map['nextchange'] != null ? DateTimeHelper.fromMillisecondsSinceEpoch((map['nextchange'] ?? 0) as int) : null,
    );
  }
}
