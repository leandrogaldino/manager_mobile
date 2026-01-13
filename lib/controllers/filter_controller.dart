import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterController extends ChangeNotifier {
  DateTimeRange? selectedDateRange;
  String searchText = '';

  bool filterBarVisible = false;
  bool showFilterButton = true;

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
