enum InterfaceDirectionTypes {
  none,
  ascending,
  descending;

  String get stringValue {
    switch (this) {
      case InterfaceDirectionTypes.none:
        return 'N/A';
      case InterfaceDirectionTypes.ascending:
        return 'Crescente';
      case InterfaceDirectionTypes.descending:
        return 'Decrescente';
    }
  }
}
