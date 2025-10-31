import 'dart:convert';

class ServiceModel {
  final int id;
  final bool visible;
  final String name;
  final DateTime lastUpdate;

  ServiceModel({
    required this.id,
    required this.visible,
    required this.name,
    required this.lastUpdate,
  });

  ServiceModel copyWith({
    int? id,
    bool? visible,
    String? name,
    DateTime? lastUpdate,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      name: name ?? this.name,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'name': name,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: (map['id'] ?? 0) as int,
      visible: (map['visible'] ?? false) as bool,
      name: (map['name'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) => ServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Service(id: $id, visible: $visible, name: $name, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ServiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.name == name && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ name.hashCode ^ lastUpdate.hashCode;
  }
}
