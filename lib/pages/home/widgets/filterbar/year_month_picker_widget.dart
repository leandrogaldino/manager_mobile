import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:manager_mobile/models/year_month_model.dart';

class YearMonthPickerWidget extends StatefulWidget {
  final Map<int, List<int>> dataSet;
  final YearMonthModel selectedYearMonth;

  final Function(YearMonthModel yearMonth) onSelected;

  const YearMonthPickerWidget({
    super.key,
    required this.dataSet,
    required this.selectedYearMonth,
    required this.onSelected,
  });

  @override
  State<YearMonthPickerWidget> createState() => _YearMonthPickerWidgetState();
}

class _YearMonthPickerWidgetState extends State<YearMonthPickerWidget> {
  late List<String> months;
  late List<int> years;
  late YearMonthModel yearMonth;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;

  @override
  void initState() {
    super.initState();
    yearMonth = widget.selectedYearMonth;

    months = StringHelper.getMonthNames(widget.dataSet[yearMonth.year] ?? []);
    int minYear = widget.dataSet.keys.reduce((a, b) => a < b ? a : b);
    int maxYear = widget.dataSet.keys.reduce((a, b) => a > b ? a : b);

    years = List.generate(maxYear - minYear + 1, (index) => minYear + index);

    if (years.isEmpty) {
      months = [];
    } else {
      for (var year in List.from(years.reversed)) {
        var monthsOfYear = widget.dataSet[year] ?? [];
        if (monthsOfYear.isEmpty) {
          years.remove(year);
        }
      }
    }

    yearController = FixedExtentScrollController(
      initialItem: years.indexOf(yearMonth.year),
    );

    monthController = FixedExtentScrollController(
      initialItem: yearMonth.month - 1,
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
            years.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'Não há datas disponíveis para filtrar.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Padding(
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
                                  months = StringHelper.getMonthNames(widget.dataSet[yearMonth.year] ?? []);
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      years[index].toString(),
                                      style: textTheme.bodyLarge!.copyWith(
                                        color: yearController.selectedItem == index ? colorScheme.secondary : colorScheme.onSecondary,
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
                                  yearMonth.month = index;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      months[index],
                                      style: textTheme.bodyLarge!.copyWith(
                                        color: monthController.selectedItem == index ? colorScheme.secondary : colorScheme.onSecondary,
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
              mainAxisAlignment: years.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                Offstage(
                  offstage: years.isEmpty,
                  child: TextButton(
                    onPressed: () {
                      final selectedYear = years[yearController.selectedItem];
                      final selectedMonth = monthController.selectedItem;
                      widget.onSelected(YearMonthModel(year: selectedYear, month: selectedMonth));
                      Navigator.pop(context);
                    },
                    child: Text('Confirmar'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
