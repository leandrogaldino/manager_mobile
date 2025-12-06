enum CallTypes {
  none,
  gathering,
  preventive,
  corrective,
  contract;

  String get stringValue {
    switch (this) {
      case CallTypes.none:
        return '';
      case CallTypes.gathering:
        return 'Levantamento';
      case CallTypes.preventive:
        return 'Preventiva';
      case CallTypes.corrective:
        return 'Corretiva';
      case CallTypes.contract:
        return 'Contrato';
    }
  }
}
