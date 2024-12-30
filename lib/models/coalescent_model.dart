// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CoalescentModel {
  final int id;
  final String coalescentName;
  final DateTime lastUpdate;

  CoalescentModel({
    required this.id,
    required this.coalescentName,
    required this.lastUpdate,
  });

  CoalescentModel copyWith({
    int? id,
    String? coalescentName,
    DateTime? lastUpdate,
  }) {
    return CoalescentModel(
      id: id ?? this.id,
      coalescentName: coalescentName ?? this.coalescentName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'coalescentName': coalescentName,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory CoalescentModel.fromMap(Map<String, dynamic> map) {
    return CoalescentModel(
      id: (map['id'] ?? 0) as int,
      coalescentName: (map['coalescentName'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoalescentModel.fromJson(String source) => CoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CoalescentModel(id: $id, coalescentName: $coalescentName, lastUpdate: $lastUpdate)';

  @override
  bool operator ==(covariant CoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.coalescentName == coalescentName && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode => id.hashCode ^ coalescentName.hashCode ^ lastUpdate.hashCode;
}
