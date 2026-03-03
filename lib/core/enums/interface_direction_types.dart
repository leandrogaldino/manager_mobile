enum InterfaceDirectionTypes {
  ascending,
  descending;

  String get stringValue {
    switch (this) {
      case InterfaceDirectionTypes.ascending:
        return 'Crescente';
      case InterfaceDirectionTypes.descending:
        return 'Decrescente';
    }
  }
}
