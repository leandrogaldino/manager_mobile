import 'dart:convert';
import 'package:manager_mobile/models/product_model.dart';

class EvaluationReplacedProductModel {
  final int? id;
  final double quantity;
  final ProductModel product;

  EvaluationReplacedProductModel({
    this.id,
    required this.quantity,
    required this.product,
  });


  EvaluationReplacedProductModel copyWith({
    int? id,
    double? quantity,
    ProductModel? product,
  }) {
    return EvaluationReplacedProductModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'product': product.toMap(),
    };
  }

  factory EvaluationReplacedProductModel.fromMap(Map<String, dynamic> map) {
    return EvaluationReplacedProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: (map['quantity'] ?? 0.0) as double,
      product: ProductModel.fromMap(map['product'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationReplacedProductModel.fromJson(String source) => EvaluationReplacedProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationReplacedProduct(id: $id, quantity: $quantity, product: $product)';

  @override
  bool operator ==(covariant EvaluationReplacedProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.quantity == quantity &&
      other.product == product;
  }

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode ^ product.hashCode;
}
