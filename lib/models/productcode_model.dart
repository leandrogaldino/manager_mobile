import 'dart:convert';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/product_model.dart';

class ProductCodeModel {
  final int id;
  final bool visible;
  final bool isMain;
  final String code;
  final DateTime lastUpdate;

  ProductCodeModel({
    required this.id,
    required this.visible,
    required this.isMain,
    required this.code,
    required this.lastUpdate,
  });

  ProductCodeModel copyWith({
    int? id,
    bool? visible,
    bool? isMain,
    ProductModel? product,
    String? code,
    DateTime? lastUpdate,
  }) {
    return ProductCodeModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      isMain: isMain ?? this.isMain,
      code: code ?? this.code,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'ismain': isMain,
      'code': code,
      'lastupdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ProductCodeModel.fromMap(Map<String, dynamic> map) {
    return ProductCodeModel(
      id: (map['id'] ?? 0) as int,
      visible: map['visible'] == 0 ? false : true,
      isMain: map['ismain'] == 0 ? false : true,
      code: (map['code'] ?? '') as String,
      lastUpdate: DateTimeHelper.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCodeModel.fromJson(String source) => ProductCodeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductCodeModel(id: $id, visible: $visible, isMain: $isMain, code: $code, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ProductCodeModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.isMain == isMain && other.code == code && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ isMain.hashCode ^ code.hashCode ^ lastUpdate.hashCode;
  }
}
