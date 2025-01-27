import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';

class FilterBarWidget extends StatefulWidget {
  const FilterBarWidget({super.key});

  @override
  State<FilterBarWidget> createState() => _FilterBarWidgetState();
}

class _FilterBarWidgetState extends State<FilterBarWidget> {
  late final FilterController filterController;
  late final HomeController homeController;
  late final TextEditingController customerControllerEC;
  late final TextEditingController dateControllerEC;

  @override
  void initState() {
    super.initState();
    filterController = Locator.get<FilterController>();
    homeController = Locator.get<HomeController>();
    customerControllerEC = TextEditingController();
    dateControllerEC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: filterController,
      builder: (context, child) {
        return ClipRect(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: filterController.filterBarHeight.toDouble(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filterController.filtering)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            customerControllerEC.clear();
                            dateControllerEC.clear();
                            filterController.setCustomerOrCompressorText('');
                            filterController.setSelectedDateRange(null);
                            await homeController.fetchData();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Limpar Filtro',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    TextField(
                      controller: customerControllerEC,
                      onChanged: (text) async {
                        filterController.setCustomerOrCompressorText(text);
                        await homeController.fetchData(customerOrCompressor: customerControllerEC.text);
                      },
                      decoration: InputDecoration(
                        labelText: "Cliente/Compressor",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: dateControllerEC,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Data",
                        prefixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDateRange: filterController.selectedDateRange,
                        );
                        filterController.setSelectedDateRange(picked);
                        dateControllerEC.text = filterController.selectedDateRangeText;
                        await homeController.fetchData(customerOrCompressor: customerControllerEC.text, dateRange: picked);
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    customerControllerEC.dispose();
    dateControllerEC.dispose();
    super.dispose();
  }
}
