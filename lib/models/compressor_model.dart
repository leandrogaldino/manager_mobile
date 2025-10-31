import 'dart:convert';

class CompressorModel {
  final int id;
  final String name;
  final bool visible;
  final DateTime lastUpdate;

  CompressorModel({
    required this.id,
    required this.name,
    required this.visible,
    required this.lastUpdate,
  });

  CompressorModel copyWith({
    int? id,
    String? name,
    bool? visible,
    DateTime? lastUpdate,
  }) {
    return CompressorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'visible': visible,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory CompressorModel.fromMap(Map<String, dynamic> map) {
    return CompressorModel(
      id: (map['id'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      visible: map['visible'] == 0 ? false : true,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompressorModel.fromJson(String source) => CompressorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompressorModel(id: $id, name: $name, visible: $visible, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant CompressorModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.visible == visible && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ visible.hashCode ^ lastUpdate.hashCode;
  }
}
