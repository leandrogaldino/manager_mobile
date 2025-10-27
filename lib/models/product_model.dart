import 'dart:convert';

import 'package:manager_mobile/models/productcode_model.dart';

class ProductModel {
  final int id;
  final bool visible;
  final String name;
  final ProductCodeModel code;
  final DateTime lastUpdate;

  ProductModel({
    required this.id,
    required this.visible,
    required this.name,
    required this.code,
    required this.lastUpdate,
  });

  ProductModel copyWith({
    int? id,
    bool? visible,
    String? name,
    ProductCodeModel? code,
    DateTime? lastUpdate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      name: name ?? this.name,
      code: code ?? this.code,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'name': name,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: (map['id'] ?? 0) as int,
      visible: (map['visible'] ?? false) as bool,
      name: (map['name'] ?? '') as String,
      code: ProductCodeModel.fromMap(map['code']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, visible: $visible, name: $name, code: $code, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.name == name && other.code == code && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ name.hashCode ^ code.hashCode ^ lastUpdate.hashCode;
  }
}
