import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/services/data_service.dart';
import 'package:manager_mobile/services/filter_service.dart';
import 'package:manager_mobile/services/sync_service.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomeController extends ChangeNotifier {
  final SyncService _syncService;
  final DataService _dataService;
  final FilterService _filterService;

  HomeController({
    required SyncService syncService,
    required DataService dataService,
    required FilterService filterService,
  })  : _syncService = syncService,
        _dataService = dataService,
        _filterService = filterService;

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  HomeStateSuccess? _lastSuccessState;
  HomeStateSuccess? get lastSuccessState => _lastSuccessState;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // --- propriedades de filtro (antes no FilterController) ---
  bool _filtering = false;
  bool get filtering => _filtering;

  DateTimeRange? _selectedDateRange;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  String _typedCustomerOrCompressorText = '';
  String get typedCustomerOrCompressorText => _typedCustomerOrCompressorText;

  bool _showFilterButton = true;
  bool get showFilterButton => _showFilterButton;

  int _filterBarHeight = 0;
  int get filterBarHeight => _filterBarHeight;

  void _updateFilterBarHeight() {
    if (_filterBarVisible) {
      _filterBarHeight = filtering ? 170 : 145;
    } else {
      _filterBarHeight = 0;
    }
  }

  String get selectedDateRangeText {
    if (_selectedDateRange == null) return '';
    String initialDate = DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start);
    String finalDate = DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end);
    return initialDate == finalDate ? initialDate : '$initialDate até $finalDate';
  }

  // --- métodos internos ---
  void _setState(HomeState newState) {
    _state = newState;
    if (newState is HomeStateSuccess) {
      _lastSuccessState = newState;
    }
    notifyListeners();
  }

  void _updateFiltering() {
    _filtering = _selectedDateRange != null || _typedCustomerOrCompressorText.isNotEmpty;
    _filterBarHeight = _filtering ? 170 : 145;
    if (!_filtering) _filterBarHeight = 0;
  }

  // --- métodos públicos ---
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setCustomerOrCompressorText(String text) {
    _typedCustomerOrCompressorText = text;
    _updateFiltering();
    notifyListeners();
  }

  void setSelectedDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    _updateFiltering();
    notifyListeners();
  }

  void setShowFilterButton(bool show) {
    _showFilterButton = show;
    notifyListeners();
  }

  Future<void> synchronize({bool showLoading = false}) async {
    try {
      if (showLoading) _setState(HomeStateLoading());

      int totalCount = await _syncService.runSync();
      await _dataService.fetchAllIfNeeded(totalCount > 0);

      final filtered = _filterService.applyFilters(
        visitSchedules: _dataService.visitSchedules,
        evaluations: _dataService.evaluations,

      );

      _setState(HomeStateSuccess(filtered.visitSchedules, filtered.evaluations));
    } catch (e) {
      _setState(HomeStateError(e.toString()));
    }
  }

  Future<void> applyFilters() async {
    final filtered = _filterService.applyFilters(
      visitSchedules: _dataService.visitSchedules,
      evaluations: _dataService.evaluations,

    );
    _setState(HomeStateSuccess(filtered.visitSchedules, filtered.evaluations));
  }

  bool _filterBarVisible = true;
  bool get filterBarVisible => _filterBarVisible;
  void toggleFilterBarVisible() {
    _filterBarVisible = !_filterBarVisible;
    _updateFilterBarHeight();
    notifyListeners();
  }
}
