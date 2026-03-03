import 'dart:convert';
import 'package:manager_mobile/core/enums/interface_direction_types.dart';

class CompressorInterfaceModel {
  final int id;
  final String name;
  final bool visible;
  final InterfaceDirectionTypes direction;
  final DateTime lastUpdate;

  CompressorInterfaceModel({
    required this.id,
    required this.name,
    required this.visible,
    required this.direction,
    required this.lastUpdate,
  });

  CompressorInterfaceModel copyWith({
    int? id,
    String? name,
    bool? visible,
    InterfaceDirectionTypes? direction,
    DateTime? lastUpdate,
  }) {
    return CompressorInterfaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      direction: direction ?? this.direction,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'visible': visible,
      'directionid': direction.index,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory CompressorInterfaceModel.fromMap(Map<String, dynamic> map) {
    return CompressorInterfaceModel(
      id: (map['id'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      visible: (map['visible'] ?? false) as bool,
      direction: InterfaceDirectionTypes.values[map['directionid'] as int],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompressorInterfaceModel.fromJson(String source) => CompressorInterfaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompressorInterfaceModel(id: $id, name: $name, visible: $visible, direction: $direction, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant CompressorInterfaceModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.visible == visible && other.direction == direction && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ visible.hashCode ^ direction.hashCode ^ lastUpdate.hashCode;
  }
}
