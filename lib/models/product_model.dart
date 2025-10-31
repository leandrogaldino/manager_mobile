import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:manager_mobile/models/productcode_model.dart';

class ProductModel {
  final int id;
  final bool visible;
  final String name;
  final List<ProductCodeModel> codes;
  final DateTime lastUpdate;

  ProductModel({
    required this.id,
    required this.visible,
    required this.name,
    required this.codes,
    required this.lastUpdate,
  });

  ProductModel copyWith({
    int? id,
    bool? visible,
    String? name,
    List<ProductCodeModel>? codes,
    DateTime? lastUpdate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      name: name ?? this.name,
      codes: codes ?? this.codes,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] == 0 ? false : true,
      name: (map['name'] ?? '') as String,
      codes: List<ProductCodeModel>.from(
        (map['codes'] as List<Map<String, dynamic>>).map<ProductCodeModel>(
          (x) => ProductCodeModel.fromMap(x),
        ),
      ),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'name': name,
      'codes': codes.map((x) => x.toMap),
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, visible: $visible, name: $name, code: $codes, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
    return other.id == id && other.visible == visible && other.name == name && listEquals(other.codes, codes) && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ name.hashCode ^ codes.hashCode ^ lastUpdate.hashCode;
  }
}
