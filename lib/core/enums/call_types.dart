enum CallTypes {
  gathering,
  preventive,
  corrective,
  contract,
  none;

  String get stringValue {
    switch (this) {
      case CallTypes.gathering:
        return 'Levantamento';
      case CallTypes.preventive:
        return 'Preventiva';
      case CallTypes.corrective:
        return 'Corretiva';
      case CallTypes.contract:
        return 'Contrato';
      case CallTypes.none:
        return '';
    }
  }
}
