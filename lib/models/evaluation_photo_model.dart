import 'dart:convert';

class EvaluationPhotoModel {
  final int? id;
  String? localPath;
  String? cloudPath;
  String? tempPath;
  EvaluationPhotoModel({
    this.id,
    this.localPath,
    this.cloudPath,
    this.tempPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'localpath': localPath,
      'cloudpath': cloudPath,
      'temppath': tempPath,
    };
  }

  factory EvaluationPhotoModel.fromMap(Map<String, dynamic> map) {
    return EvaluationPhotoModel(
      id: map['id'] != null ? map['id'] as int : null,
      localPath: map['localpath'] != null ? map['localpath'] as String : null,
      cloudPath: map['cloudpath'] != null ? map['cloudpath'] as String : null,
      tempPath: map['temppath'] != null ? map['temppath'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationPhotoModel.fromJson(String source) => EvaluationPhotoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationImageModel(id: $id, localPath: $localPath, cloudPath: $cloudPath, tempPath: $tempPath)';

  @override
  bool operator ==(covariant EvaluationPhotoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.localPath == localPath && other.cloudPath == cloudPath && other.tempPath == tempPath;
  }

  @override
  int get hashCode => id.hashCode ^ localPath.hashCode ^ cloudPath.hashCode ^ tempPath.hashCode;
}
