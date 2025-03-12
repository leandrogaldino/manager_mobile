class YearMonthModel {
  int year;
  int month;
  YearMonthModel({
    required this.year,
    required this.month,
  });

  DateTime get firstDay => DateTime(year, month, 1);
  DateTime get lastDay => DateTime(year, month + 1, 0);

  String get monthName {
    const months = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
    return months[month];
  }

  @override
  String toString() => '$monthName de $year';
}
