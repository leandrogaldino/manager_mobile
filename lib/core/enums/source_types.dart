enum SourceTypes {
  fromNew,
  fromSchedule,
  fromSavedWithSign,
  fromSavedWithoutSign;

  String get stringValue {
    switch (this) {
      case SourceTypes.fromNew:
        return 'De uma nova';
      case SourceTypes.fromSchedule:
        return 'De um agendamento de visita';
      case SourceTypes.fromSavedWithSign:
        return 'De uma Salva com assinatura';
      case SourceTypes.fromSavedWithoutSign:
        return 'De uma Salva sem assinatura';
    }
  }
}
