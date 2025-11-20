enum OilTypes {
  mineral,
  semiSynthetic,
  synthetic,
  none;

  String get stringValue {
    switch (this) {
      case OilTypes.mineral:
        return 'Mineral';
      case OilTypes.semiSynthetic:
        return 'Semi-Sintético';
      case OilTypes.synthetic:
        return 'Sintético';
      case OilTypes.none:
        return '';
    }
  }
}
