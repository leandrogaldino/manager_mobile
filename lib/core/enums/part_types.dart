enum PartTypes {
  airFilter,
  oilFilter,
  separator,
  oil,
  greasing;

  String get stringValue {
    switch (this) {
      case PartTypes.airFilter:
        return 'Filtro de Ar';
      case PartTypes.oilFilter:
        return 'Filtro de Óleo';
      case PartTypes.separator:
        return 'Elemento Separador';
      case PartTypes.oil:
        return 'Óleo';
      case PartTypes.greasing:
        return 'Engraxamento';
    }
  }
}
