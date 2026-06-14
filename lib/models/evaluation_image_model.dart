import 'dart:convert';

class EvaluationImageModel {
  final int? id;
  String? localPath;
  String? cloudPath;
  EvaluationImageModel({
    this.id,
    this.localPath,
    this.cloudPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'localpath': localPath,
      'cloudpath': cloudPath,
    };
  }

  factory EvaluationImageModel.fromMap(Map<String, dynamic> map) {
    return EvaluationImageModel(
      id: map['id'] != null ? map['id'] as int : null,
      localPath: map['localpath'] != null ? map['localpath'] as String : null,
      cloudPath: map['cloudpath'] != null ? map['cloudpath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationImageModel.fromJson(String source) => EvaluationImageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationImageModel(id: $id, localPath: $localPath, cloudPath: $cloudPath)';

  @override
  bool operator ==(covariant EvaluationImageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.localPath == localPath && other.cloudPath == cloudPath;
  }

  @override
  int get hashCode => id.hashCode ^ localPath.hashCode ^ cloudPath.hashCode;
}
