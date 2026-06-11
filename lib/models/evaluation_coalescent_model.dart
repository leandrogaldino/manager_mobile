import 'dart:convert';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/personcompressorcoalescent_model.dart';

class EvaluationCoalescentModel {
  int? id;
  PersonCompressorCoalescentModel coalescent;
  bool ignoreNextChange;
  DateTime? nextChange;

  EvaluationCoalescentModel({
    this.id,
    required this.coalescent,
    this.ignoreNextChange = false,
    this.nextChange,
  });

  String toJson() => json.encode(toMap());

  factory EvaluationCoalescentModel.fromJson(String source) => EvaluationCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationCoalescentModel(id: $id, coalescent: $coalescent, ignoreNextChange: $ignoreNextChange, nextChange: $nextChange)';

  @override
  bool operator ==(covariant EvaluationCoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.coalescent == coalescent && other.ignoreNextChange == ignoreNextChange && other.nextChange == nextChange;
  }

  @override
  int get hashCode => id.hashCode ^ coalescent.hashCode ^ ignoreNextChange.hashCode ^ nextChange.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'coalescentid': coalescent.id,
      'ignorenextchange': ignoreNextChange ? 1 : 0,
      'nextchange': nextChange?.toUtc().millisecondsSinceEpoch,
    };
  }

  factory EvaluationCoalescentModel.fromMap(Map<String, dynamic> map) {
    return EvaluationCoalescentModel(
      id: map['id'] != null ? map['id'] as int : null,
      coalescent: PersonCompressorCoalescentModel.fromMap(map['coalescent'] as Map<String, dynamic>),
      ignoreNextChange: map['ignorenextchange'] == 1 ? true : false,
      nextChange: map['nextchange'] != null ? DateTimeHelper.fromMillisecondsSinceEpoch((map['nextchange'] ?? 0) as int) : null,
    );
  }
}
