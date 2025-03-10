import 'package:flutter/material.dart';
import 'package:manager_mobile/models/year_month_model.dart';

class YearMonthPickerWidget extends StatefulWidget {
  final int startYear;
  final int endYear;
  final YearMonthModel selectedYearMonth;

  final Function(YearMonthModel yearMonth) onSelected;

  const YearMonthPickerWidget({
    super.key,
    required this.startYear,
    required this.endYear,
    required this.selectedYearMonth,
    required this.onSelected,
  });

  @override
  State<YearMonthPickerWidget> createState() => _YearMonthPickerWidgetState();
}

class _YearMonthPickerWidgetState extends State<YearMonthPickerWidget> {
  final List<String> months = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
  late List<int> years;
  late YearMonthModel yearMonth;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;

  @override
  void initState() {
    super.initState();
    yearMonth = widget.selectedYearMonth;
    years = List.generate(widget.endYear - widget.startYear + 1, (index) => widget.startYear + index);

    yearController = FixedExtentScrollController(
      initialItem: years.indexOf(yearMonth.year),
    );

    monthController = FixedExtentScrollController(
      initialItem: yearMonth.month - 1, // Índices começam em 0
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 0),
      child: SizedBox(
        height: 290,
        child: Column(
          children: [
            Text('Selecione o Ano/Mês', style: textTheme.titleSmall),
            SizedBox(height: 10),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: yearController,
                        itemExtent: 40,
                        diameterRatio: 100,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            yearMonth.year = years[index];
                            //widget.onSelected(yearMonth);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                years[index].toString(),
                                style: textTheme.bodyLarge!.copyWith(
                                  color: yearMonth.year == years[index] ? colorScheme.secondary : colorScheme.onSecondary,
                                ),
                              ),
                            );
                          },
                          childCount: years.length,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: monthController,
                        itemExtent: 40,
                        diameterRatio: 100,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            yearMonth = YearMonthModel(year: yearMonth.year, month: index + 1);
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                months[index],
                                style: textTheme.bodyLarge!.copyWith(
                                  color: yearMonth.monthName == months[index] ? colorScheme.secondary : colorScheme.onSecondary,
                                ),
                              ),
                            );
                          },
                          childCount: months.length,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    final selectedYear = years[yearController.selectedItem];
                    final selectedMonth = monthController.selectedItem + 1;
                    widget.onSelected(YearMonthModel(year: selectedYear, month: selectedMonth));
                    Navigator.pop(context);
                  },
                  child: Text('Confirmar'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
