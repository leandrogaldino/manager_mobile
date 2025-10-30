import 'dart:convert';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/product_model.dart';

class PersonCompressorCoalescentModel {
  final int id;
  final bool visible;
  final PersonCompressorModel compressor;
  final ProductModel product;
  final DateTime lastUpdate;
  PersonCompressorCoalescentModel({
    required this.id,
    required this.visible,
    required this.compressor,
    required this.product,
    required this.lastUpdate,
  });

  PersonCompressorCoalescentModel copyWith({
    int? id,
    bool? visible,
    PersonCompressorModel? compressor,
    ProductModel? product,
    DateTime? lastUpdate,
  }) {
    return PersonCompressorCoalescentModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      compressor: compressor ?? this.compressor,
      product: product ?? this.product,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'compressor': compressor.toMap(),
      'product': product.toMap(),
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory PersonCompressorCoalescentModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorCoalescentModel(
      id: (map['id'] ?? 0) as int,
      visible: (map['visible'] ?? false) as bool,
      compressor: PersonCompressorModel.fromMap(map['compressor']),
      product: ProductModel.fromMap(map['product']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastupdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorCoalescentModel.fromJson(String source) => PersonCompressorCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonCompressorCoalescentModel(id: $id, visible: $visible, compressor: $compressor,  product: $product, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant PersonCompressorCoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.compressor == compressor && other.product == product && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ compressor.hashCode ^ product.hashCode ^ lastUpdate.hashCode;
  }
}
