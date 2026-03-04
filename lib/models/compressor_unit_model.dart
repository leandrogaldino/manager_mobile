import 'dart:convert';

class CompressorUnitModel {
  final int id;
  final String name;
  final bool visible;
  final DateTime lastUpdate;

  CompressorUnitModel({
    required this.id,
    required this.name,
    required this.visible,
    required this.lastUpdate,
  });

  CompressorUnitModel copyWith({
    int? id,
    String? name,
    bool? visible,
    DateTime? lastUpdate,
  }) {
    return CompressorUnitModel(
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
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory CompressorUnitModel.fromMap(Map<String, dynamic> map) {
    return CompressorUnitModel(
      id: (map['id'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      visible: map['visible'] == 0 ? false : true,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompressorUnitModel.fromJson(String source) => CompressorUnitModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompressorUnitModel(id: $id, name: $name, visible: $visible, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant CompressorUnitModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.visible == visible && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ visible.hashCode ^ lastUpdate.hashCode;
  }
}
