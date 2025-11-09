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
  late final FilterController _filterController;
  late final HomeController _homeController;
  late final TextEditingController _customerControllerEC;
  late final TextEditingController _dateControllerEC;

  @override
  void initState() {
    super.initState();
    _filterController = Locator.get<FilterController>();
    _homeController = Locator.get<HomeController>();
    _customerControllerEC = TextEditingController();
    _dateControllerEC = TextEditingController();
  }

  @override
  void dispose() {
    _customerControllerEC.dispose();
    _dateControllerEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _filterController,
      builder: (context, child) {
        return ClipRect(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: _filterController.filterBarHeight.toDouble(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_filterController.filtering)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            _customerControllerEC.clear();
                            _dateControllerEC.clear();
                            _filterController.setCustomerOrCompressorText('');
                            _filterController.setSelectedDateRange(null);
                            await _homeController.fetchData();
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
                      controller: _customerControllerEC,
                      onChanged: (text) async {
                        _filterController.setCustomerOrCompressorText(text);
                        _homeController.setCustomerOrCompressorFilter(text);                       
                        await _homeController.fetchData(customerOrCompressor: _homeController.customerOrCompressor, dateRange: _homeController.dateRange);
                      },
                      decoration: InputDecoration(
                        labelText: "Cliente/Compressor",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: _dateControllerEC,
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
                          initialDateRange: _filterController.selectedDateRange,
                        );
                        _filterController.setSelectedDateRange(picked);
                        _homeController.setDateRangeFilter(picked);
                        _dateControllerEC.text = _filterController.selectedDateRangeText;
                        await _homeController.fetchData(customerOrCompressor: _homeController.customerOrCompressor, dateRange: _homeController.dateRange);
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
}
