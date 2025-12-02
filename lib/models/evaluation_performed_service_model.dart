import 'dart:convert';
import 'package:manager_mobile/models/service_model.dart';

class EvaluationPerformedServiceModel {
  final int? id;
  int quantity;
  final ServiceModel service;

  EvaluationPerformedServiceModel({
    this.id,
    required this.quantity,
    required this.service,
  });

  EvaluationPerformedServiceModel copyWith({
    int? id,
    int? quantity,
    ServiceModel? service,
  }) {
    return EvaluationPerformedServiceModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      service: service ?? this.service,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'service': service.toMap(),
    };
  }

  factory EvaluationPerformedServiceModel.fromMap(Map<String, dynamic> map) {
    return EvaluationPerformedServiceModel(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: (map['quantity'] ?? 0) as int,
      service: ServiceModel.fromMap(map['service'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EvaluationPerformedServiceModel.fromJson(String source) => EvaluationPerformedServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EvaluationPerformedService(id: $id, quantity: $quantity, service: $service)';

  @override
  bool operator ==(covariant EvaluationPerformedServiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.quantity == quantity && other.service == service;
  }

  @override
  int get hashCode => id.hashCode ^ quantity.hashCode ^ service.hashCode;
}
