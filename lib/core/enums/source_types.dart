enum SourceTypes {
  fromNew,
  fromSchedule,
  fromSaved;

  String get stringValue {
    switch (this) {
      case SourceTypes.fromNew:
        return 'De uma Nova';
      case SourceTypes.fromSchedule:
        return 'De uma Visita';
      case SourceTypes.fromSaved:
        return 'De uma Salva';
    }
  }
}
