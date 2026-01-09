import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:manager_mobile/services/data_service.dart';
import 'package:manager_mobile/services/filter_service.dart';
import 'package:manager_mobile/services/sync_service.dart';
import 'package:manager_mobile/states/home_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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

  DateTimeRange? get selectedDateRange => _filterService.dateRange;
  String get typedCustomerOrCompressorText => _filterService.text;

  bool get synchronizing => _syncService.synchronizing;

  void setCustomerOrCompressorText(String text) {
    _filterService.text = text;
    _updateFiltering();
    notifyListeners();
  }

  void setSelectedDateRange(DateTimeRange? range) {
    _filterService.dateRange = range;
    _updateFiltering();
    notifyListeners();
  }

  String get selectedDateRangeText {
    if (_filterService.dateRange == null) return '';
    String initialDate = DateFormat('dd/MM/yyyy').format(_filterService.dateRange!.start);
    String finalDate = DateFormat('dd/MM/yyyy').format(_filterService.dateRange!.end);
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
    _filtering = _filterService.dateRange != null || _filterService.text.isNotEmpty;
    _filterBarHeight = _filtering ? 170 : 145;
    //if (!_filtering) _filterBarHeight = 0;
  }

  // --- métodos públicos ---
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setShowFilterButton(bool show) {
    _showFilterButton = show;
    notifyListeners();
  }

  Future<void> fetchAllIfNeeded(bool force, {bool showLoading = false}) async {
    try {
      if (showLoading) _setState(HomeStateLoading());
      await _dataService.fetchAllIfNeeded(force);

      final filtered = _filterService.applyFilters(
        visitSchedules: _dataService.visitSchedules,
        evaluations: _dataService.evaluations,
      );

      bool done = await _syncService.firstSyncSuccessfulDone;
      if (!done) {
        _setState(HomeStateLoading());
      } else {
        _setState(HomeStateSuccess(filtered.visitSchedules, filtered.evaluations));
      }
    } catch (e) {
      _setState(HomeStateError(e.toString()));
    }
  }

  Future<void> synchronize({bool showLoading = false, bool isAuto = false}) async {
    int totalCount = 0;
    await WakelockPlus.enable();
    try {
      if (showLoading) _setState(HomeStateLoading());
      bool hasConnection = await InternetConnection().hasInternetAccess;
      if (hasConnection) {
        totalCount = await _syncService.runSync(isAuto: isAuto);
      } else {
        _setState(HomeStateInfo(infoMessage: 'Sem conexão com a internet'));
      }
      fetchAllIfNeeded(totalCount > 0, showLoading: showLoading);
    } catch (e) {
      _setState(HomeStateError(e.toString()));
    } finally {
      await WakelockPlus.disable();
    }
  }

  Future<void> applyFilters() async {
    final filtered = _filterService.applyFilters(
      visitSchedules: _dataService.visitSchedules,
      evaluations: _dataService.evaluations,
    );
    _setState(HomeStateSuccess(filtered.visitSchedules, filtered.evaluations));
  }

  bool _filterBarVisible = false;
  bool get filterBarVisible => _filterBarVisible;
  void toggleFilterBarVisible() {
    _filterBarVisible = !_filterBarVisible;
    _updateFilterBarHeight();
    notifyListeners();
  }
}
