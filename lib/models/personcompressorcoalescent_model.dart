import 'dart:convert';

class PersonCompressorCoalescentModel {
  final int id;
  final bool visible;
  final String coalescentName;
  final DateTime lastUpdate;
  PersonCompressorCoalescentModel({
    required this.id,
    required this.visible,
    required this.coalescentName,
    required this.lastUpdate,
  });

  PersonCompressorCoalescentModel copyWith({
    int? id,
    bool? visible,
    String? coalescentName,
    DateTime? lastUpdate,
  }) {
    return PersonCompressorCoalescentModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      coalescentName: coalescentName ?? this.coalescentName,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'coalescentname': coalescentName,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory PersonCompressorCoalescentModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorCoalescentModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] as int == 0 ? false : true,
      coalescentName: (map['coalescentname'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorCoalescentModel.fromJson(String source) => PersonCompressorCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CoalescentModel(id: $id, visible: $visible, coalescentName: $coalescentName, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant PersonCompressorCoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.coalescentName == coalescentName && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ coalescentName.hashCode ^ lastUpdate.hashCode;
  }
}
