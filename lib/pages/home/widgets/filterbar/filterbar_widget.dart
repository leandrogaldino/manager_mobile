import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/services/data_service.dart';

class FilterBarWidget extends StatefulWidget {
  const FilterBarWidget({super.key});

  @override
  State<FilterBarWidget> createState() => _FilterBarWidgetState();
}

class _FilterBarWidgetState extends State<FilterBarWidget> {
  late final DataService _dataService;
  late final HomeController _homeController;
  late final TextEditingController _customerControllerEC;
  late final TextEditingController _dateControllerEC;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _homeController = Locator.get<HomeController>();
    _dataService = Locator.get<DataService>();
    _customerControllerEC = TextEditingController();
    _dateControllerEC = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _customerControllerEC.dispose();
    _dateControllerEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _homeController,
      builder: (context, child) {
        return ClipRect(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: _homeController.filter.filterBarHeight.toDouble(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_homeController.filter.filtering)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            _customerControllerEC.clear();
                            _dateControllerEC.clear();
                            _homeController.filter.clear();
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
                        _searchDebounce?.cancel();
                        _searchDebounce = Timer(
                          const Duration(milliseconds: 400),
                          () {
                            _homeController.filter.setSearchText(text);
                          },
                        );
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
                          firstDate: _dataService.firstEvaluationOrVisitScheduleDate ?? DateTimeHelper.create(2000),
                          lastDate: _dataService.lastEvaluationOrVisitScheduleDate ?? DateTimeHelper.create(2100),
                          initialDateRange: _homeController.filter.selectedDateRange,
                        );

                        _homeController.filter.setDateRange(picked);
                        _dateControllerEC.text = _homeController.filter.selectedDateRangeText;
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
