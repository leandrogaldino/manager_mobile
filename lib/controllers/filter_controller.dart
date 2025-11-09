import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterController extends ChangeNotifier {
  bool _filterBarVisible = false;
  bool get filterBarVisible => _filterBarVisible;
  void toggleFilterBarVisible() {
    _filterBarVisible = !_filterBarVisible;
    setFilterBarHeight();
  }

  int _filterBarHeight = 0;
  int get filterBarHeight => _filterBarHeight;
  void setFilterBarHeight() {
    if (filterBarVisible) {
      if (filtering) {
        _filterBarHeight = 170;
      } else {
        _filterBarHeight = 145;
      }
    } else {
      _filterBarHeight = 0;
    }
    notifyListeners();
  }

  bool _filtering = false;
  bool get filtering => _filtering;

  DateTimeRange? _selectedDateRange;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  void setSelectedDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    if (_selectedDateRange != null || _typedCustomerOrCompressorText != '') {
      _filtering = true;
      setFilterBarHeight();
    } else {
      _filtering = false;
      setFilterBarHeight();
    }
  }

  String get selectedDateRangeText {
    if (_selectedDateRange == null) return '';
    String initialDate = DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start);
    String finalDate = DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end);
    if (initialDate == finalDate) return initialDate;
    return '$initialDate até $finalDate';
  }

  String _typedCustomerOrCompressorText = '';
  String get typedCustomerOrCompressorText => _typedCustomerOrCompressorText;
  void setCustomerOrCompressorText(String text) {
    _typedCustomerOrCompressorText = text;
    if (_selectedDateRange != null || _typedCustomerOrCompressorText != '') {
      _filtering = true;
      setFilterBarHeight();
    } else {
      _filtering = false;
      setFilterBarHeight();
    }
  }
}
