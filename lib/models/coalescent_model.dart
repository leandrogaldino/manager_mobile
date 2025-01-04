import 'dart:convert';

class CoalescentModel {
  final int id;
  final int statusId;
  final String coalescentName;
  final DateTime lastUpdate;
  CoalescentModel({
    required this.id,
    required this.statusId,
    required this.coalescentName,
    required this.lastUpdate,
  });

  CoalescentModel copyWith({
    int? id,
    int? statusId,
    String? coalescentName,
    DateTime? lastUpdate,
  }) {
    return CoalescentModel(
      id: id ?? this.id,
      statusId: statusId ?? this.statusId,
      coalescentName: coalescentName ?? this.coalescentName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'statusid': statusId,
      'coalescentname': coalescentName,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory CoalescentModel.fromMap(Map<String, dynamic> map) {
    return CoalescentModel(
      id: (map['id'] ?? 0) as int,
      statusId: (map['statusid'] ?? 0) as int,
      coalescentName: (map['coalescentname'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoalescentModel.fromJson(String source) => CoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoalescentModel(id: $id, statusId: $statusId, coalescentName: $coalescentName, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant CoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.statusId == statusId && other.coalescentName == coalescentName && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ statusId.hashCode ^ coalescentName.hashCode ^ lastUpdate.hashCode;
  }
}
