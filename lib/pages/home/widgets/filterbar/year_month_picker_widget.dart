import 'package:flutter/material.dart';

class YearMonthPickerWidget extends StatefulWidget {
  final int startYear;
  final int endYear;
  final Function(int year, String month) onSelected;

  const YearMonthPickerWidget({
    super.key,
    required this.startYear,
    required this.endYear,
    required this.onSelected,
  });

  @override
  State<YearMonthPickerWidget> createState() => _YearMonthPickerWidgetState();
}

class _YearMonthPickerWidgetState extends State<YearMonthPickerWidget> {
  final List<String> months = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
  late List<int> years;
  int selectedYear = DateTime.now().year;
  String selectedMonth = "Janeiro";

  @override
  void initState() {
    super.initState();
    years = List.generate(widget.endYear - widget.startYear + 1, (index) => widget.startYear + index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMonth = months[index];
                  widget.onSelected(selectedYear, selectedMonth);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      months[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        //color: selectedMonth == months[index] ? Colors.red: Colors.black,
                      ),
                    ),
                  );
                },
                childCount: months.length,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedYear = years[index];
                  widget.onSelected(selectedYear, selectedMonth);
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  return Center(
                    child: Text(
                      years[index].toString(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                childCount: years.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
