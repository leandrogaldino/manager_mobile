import 'dart:convert';
import 'package:manager_mobile/models/product_model.dart';

class ProductCodeModel {
  final int id;
  final bool visible;
  final ProductModel product;
  final String code;
  final DateTime lastUpdate;

  ProductCodeModel({
    required this.id,
    required this.visible,
    required this.product,
    required this.code,
    required this.lastUpdate,
  });

  ProductCodeModel copyWith({
    int? id,
    bool? visible,
    ProductModel? product,
    String? code,
    DateTime? lastUpdate,
  }) {
    return ProductCodeModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      product: product ?? this.product,
      code: code ?? this.code,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'product': product.toMap(),
      'code': code,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ProductCodeModel.fromMap(Map<String, dynamic> map) {
    return ProductCodeModel(
      id: (map['id'] ?? 0) as int,
      visible: (map['visible'] ?? false) as bool,
      product: ProductModel.fromMap(map['product']),
      code: (map['code'] ?? '') as String,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCodeModel.fromJson(String source) => ProductCodeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductCodeModel(id: $id, visible: $visible, product: $product, code: $code, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant ProductCodeModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.product == product && other.code == code && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ product.hashCode ^ code.hashCode ^ lastUpdate.hashCode;
  }
}
