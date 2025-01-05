// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EvaluationInfoModel {
  final int id;
  final bool imported;
  final String importedBy;
  final DateTime importedDate;
  final int importedId;
  final String importingBy;
  final DateTime importingDate;

  EvaluationInfoModel({
    required this.id,
    required this.imported,
    required this.importedBy,
    required this.importedDate,
    required this.importedId,
    required this.importingBy,
    required this.importingDate,
  });

  EvaluationInfoModel copyWith({
    int? id,
    bool? imported,
    String? importedBy,
    DateTime? importedDate,
    int? importedId,
    String? importingBy,
    DateTime? importingDate,
  }) {
    return EvaluationInfoModel(
      id: id ?? this.id,
      imported: imported ?? this.imported,
      importedBy: importedBy ?? this.importedBy,
      importedDate: importedDate ?? this.importedDate,
      importedId: importedId ?? this.importedId,
      importingBy: importingBy ?? this.importingBy,
      importingDate: importingDate ?? this.importingDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imported': imported,
      'importedBy': importedBy,
      'importedDate': importedDate.millisecondsSinceEpoch,
      'importedId': importedId,
      'importingBy': importingBy,
      'importingDate': importingDate.millisecondsSinceEpoch,
    };
  }

  factory EvaluationInfoModel.fromMap(Map<String, dynamic> map) {
    return EvaluationInfoModel(
      id: (map['id'] ?? 0) as int,
      imported: (map['imported'] ?? false) as bool,
      importedBy: (map['importedBy'] ?? '') as String,
      importedDate: DateTime.fromMillisecondsSinceEpoch((map['importedDate'] ?? 0) as int),
      importedId: (map['importedId'] ?? 0) as int,
      importingBy: (map['importingBy'] ?? '') as String,
      importingDate: DateTime.fromMillisecondsSinceEpoch((map['importingDate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationInfoModel.fromJson(String source) => EvaluationInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EvaluationInfoModel(id: $id, imported: $imported, importedBy: $importedBy, importedDate: $importedDate, importedId: $importedId, importingBy: $importingBy, importingDate: $importingDate)';
  }

  @override
  bool operator ==(covariant EvaluationInfoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.imported == imported && other.importedBy == importedBy && other.importedDate == importedDate && other.importedId == importedId && other.importingBy == importingBy && other.importingDate == importingDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ imported.hashCode ^ importedBy.hashCode ^ importedDate.hashCode ^ importedId.hashCode ^ importingBy.hashCode ^ importingDate.hashCode;
  }
}
