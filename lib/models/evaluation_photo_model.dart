import 'dart:convert';

class EvaluationPhotoModel {
  final int? id;
  final String path;

  EvaluationPhotoModel({
    this.id,
    required this.path,
  });

  EvaluationPhotoModel copyWith({
    int? id,
    String? path,
  }) {
    return EvaluationPhotoModel(
      id: id ?? this.id,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'path': path,
    };
  }

  factory EvaluationPhotoModel.fromMap(Map<String, dynamic> map) {
    return EvaluationPhotoModel(
      id: map['id'] != null ? map['id'] as int : null,
      path: (map['path'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationPhotoModel.fromJson(String source) => EvaluationPhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationPhotoModel(id: $id, path: $path)';

  @override
  bool operator ==(covariant EvaluationPhotoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.path == path;
  }

  @override
  int get hashCode => id.hashCode ^ path.hashCode;
}
