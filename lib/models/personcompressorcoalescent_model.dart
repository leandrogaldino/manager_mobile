// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/product_model.dart';

class PersonCompressorCoalescentModel {
  final int id;
  final bool visible;
  final PersonCompressorModel personCompressor;
  final ProductModel product;
  final DateTime lastUpdate;
  PersonCompressorCoalescentModel({
    required this.id,
    required this.visible,
    required this.personCompressor,
    required this.product,
    required this.lastUpdate,
  });

  PersonCompressorCoalescentModel copyWith({
    int? id,
    bool? visible,
    PersonCompressorModel? personCompressor,
    ProductModel? product,
    DateTime? lastUpdate,
  }) {
    return PersonCompressorCoalescentModel(
      id: id ?? this.id,
      visible: visible ?? this.visible,
      personCompressor: personCompressor ?? this.personCompressor,
      product: product ?? this.product,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visible': visible,
      'personCompressor': personCompressor.toMap(),
      'product': product.toMap(),
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory PersonCompressorCoalescentModel.fromMap(Map<String, dynamic> map) {
    return PersonCompressorCoalescentModel(
      id: (map['id'] ?? 0) as int,
      visible: (map['visible'] ?? false) as bool,
      personCompressor: PersonCompressorModel.fromMap(map['personCompressor']),
      product: ProductModel.fromMap(map['product']),
      lastUpdate: DateTime.fromMillisecondsSinceEpoch((map['lastUpdate'] ?? 0) as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonCompressorCoalescentModel.fromJson(String source) => PersonCompressorCoalescentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonCompressorCoalescentModel(id: $id, visible: $visible, personCompressor: $personCompressor, product: $product, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(covariant PersonCompressorCoalescentModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.visible == visible && other.personCompressor == personCompressor && other.product == product && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ visible.hashCode ^ personCompressor.hashCode ^ product.hashCode ^ lastUpdate.hashCode;
  }
}
