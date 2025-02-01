enum OilTypes {
  mineral,
  semiSynthetic,
  synthetic;

  String get stringValue {
    switch (this) {
      case OilTypes.mineral:
        return 'Mineral';
      case OilTypes.semiSynthetic:
        return 'Semi-Sintético';
      case OilTypes.synthetic:
        return 'Sintético';
    }
  }
}
