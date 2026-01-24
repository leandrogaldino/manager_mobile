import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';

class FilterController extends ChangeNotifier {
  final EvaluationService _evaluationService;
  final VisitScheduleService _scheduleService;

  DateTimeRange? selectedDateRange;
  String searchText = '';

  bool filterBarVisible = false;
  bool showFilterButton = true;

  FilterController({required EvaluationService evaluationService, required VisitScheduleService scheduleService})
      : _evaluationService = evaluationService,
        _scheduleService = scheduleService;

  Future<DateTime> get minimumDate async {
    final DateTime evaluationDate = await _evaluationService.minimumDate;
    final DateTime scheduleDate = await _scheduleService.minimumDate;
    final DateTime minDate = evaluationDate.isBefore(scheduleDate) ? evaluationDate : scheduleDate;
    return minDate;
  }

  Future<DateTime> get maximumDate async {
    final DateTime evaluationDate = await _evaluationService.maximumDate;
    final DateTime scheduleDate = await _scheduleService.maximumDate;
    final DateTime maxDate = evaluationDate.isAfter(scheduleDate) ? evaluationDate : scheduleDate;
    return maxDate;
  }

  bool get filtering => selectedDateRange != null || searchText.isNotEmpty;

  int get filterBarHeight {
    if (!filterBarVisible) return 0;
    return filtering ? 170 : 145;
  }

  void setSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    selectedDateRange = range;
    notifyListeners();
  }

  void clear() {
    searchText = '';
    selectedDateRange = null;
    notifyListeners();
  }

  void toggleFilterBar() {
    filterBarVisible = !filterBarVisible;
    notifyListeners();
  }

  String get selectedDateRangeText {
    if (selectedDateRange == null) return '';
    final start = DateFormat('dd/MM/yyyy').format(selectedDateRange!.start);
    final end = DateFormat('dd/MM/yyyy').format(selectedDateRange!.end);
    return start == end ? start : '$start até $end';
  }
}
