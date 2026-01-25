enum SyncEntityType {
  evaluation,
  visitSchedule,
  compressor,
  person,
  personCompressor,
  personCompressorCoalescent,
  product,
  productCode,
  service,
}

sealed class SyncEvent {
  final SyncEntityType type;
  const SyncEvent(this.type);

  factory SyncEvent.evaluation(String uuid) = EvaluationSynced;
  factory SyncEvent.visitSchedule(int id) = VisitScheduleSynced;
  factory SyncEvent.compressor(int id) = CompressorSynced;
  factory SyncEvent.person(int id) = PersonSynced;
  factory SyncEvent.personCompressor(int id) = PersonCompressorSynced;
  factory SyncEvent.personCompressorCoalescent(int id) = PersonCompressorCoalescentSynced;
  factory SyncEvent.product(int id) = ProductSynced;
  factory SyncEvent.productCode(int id) = ProductCodeSynced;
  factory SyncEvent.service(int id) = ServiceSynced;
}

class EvaluationSynced extends SyncEvent {
  final String uuid;
  const EvaluationSynced(this.uuid) : super(SyncEntityType.evaluation);
}

class VisitScheduleSynced extends SyncEvent {
  final int id;
  const VisitScheduleSynced(this.id) : super(SyncEntityType.visitSchedule);
}

class CompressorSynced extends SyncEvent {
  final int id;
  const CompressorSynced(this.id) : super(SyncEntityType.compressor);
}

class PersonSynced extends SyncEvent {
  final int id;
  const PersonSynced(this.id) : super(SyncEntityType.person);
}

class PersonCompressorSynced extends SyncEvent {
  final int id;
  const PersonCompressorSynced(this.id) : super(SyncEntityType.personCompressor);
}

class PersonCompressorCoalescentSynced extends SyncEvent {
  final int id;
  const PersonCompressorCoalescentSynced(this.id) : super(SyncEntityType.personCompressorCoalescent);
}

class ProductSynced extends SyncEvent {
  final int id;
  const ProductSynced(this.id) : super(SyncEntityType.product);
}

class ProductCodeSynced extends SyncEvent {
  final int id;
  const ProductCodeSynced(this.id) : super(SyncEntityType.productCode);
}

class ServiceSynced extends SyncEvent {
  final int id;
  const ServiceSynced(this.id) : super(SyncEntityType.service);
}
