enum OilTypes {
  none,
  mineral,
  semiSynthetic,
  synthetic;

  String get stringValue {
    switch (this) {
      case OilTypes.none:
        return '';
      case OilTypes.mineral:
        return 'Mineral';
      case OilTypes.semiSynthetic:
        return 'Semi-Sintético';
      case OilTypes.synthetic:
        return 'Sintético';
    }
  }
}
