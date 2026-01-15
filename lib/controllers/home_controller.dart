import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/paged_list_controller.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/sync_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';
import 'package:manager_mobile/states/home_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomeController extends ChangeNotifier {
  final SyncService _syncService;
  final FilterController filter;

  late final PagedListController<EvaluationModel> evaluations;
  late final PagedListController<VisitScheduleModel> visitSchedules;

  HomeController({
    required SyncService syncService,
    required EvaluationService evaluationService,
    required VisitScheduleService visitScheduleService,
    required this.filter,
  }) : _syncService = syncService {
    evaluations = PagedListController<EvaluationModel>(
      (offset, limit) {
        return evaluationService.searchVisibles(
          offset: offset,
          limit: limit,
          search: filter.searchText,
          initialDate: filter.selectedDateRange?.start,
          finalDate: filter.selectedDateRange?.end,
        );
      },
    );

    visitSchedules = PagedListController<VisitScheduleModel>(
      (offset, limit) {
        return visitScheduleService.searchVisibles(
          offset: offset,
          limit: limit,
          search: filter.searchText,
          initialDate: filter.selectedDateRange?.start,
          finalDate: filter.selectedDateRange?.end,
        );
      },
    );
    filter.addListener(_onFilterChanged);
  }

  bool _showingUpdateBanner = false;
  bool get showingUpdateBanner => _showingUpdateBanner;

  void showUpdateBanner() {
    _showingUpdateBanner = true;
    notifyListeners();
  }

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool get synchronizing => _syncService.synchronizing;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> loadInitial() async {
    await Future.wait([
      evaluations.loadInitial(),
      visitSchedules.loadInitial(),
    ]);

    _setState(
      HomeStateSuccess(
        visitSchedules,
        evaluations,
      ),
    );
  }

  void _onFilterChanged() {
    loadInitial();
  }

  void _setState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> synchronize({
    bool showLoading = false,
    bool isAuto = false,
  }) async {
    await WakelockPlus.enable();
    try {
      if (showLoading) _setState(HomeStateLoading());

      final hasConnection = await InternetConnection().hasInternetAccess;

      if (!hasConnection) {
        _setState(
          HomeStateConnection(
            infoMessage: 'Sem conexão com a internet',
          ),
        );
        return;
      }

      final hasNewData = await _syncService.runSync(isAuto: isAuto);

      if (isAuto && hasNewData) {
        showUpdateBanner();
      }
    } catch (e) {
      _setState(HomeStateError(e.toString()));
    } finally {
      await WakelockPlus.disable();
    }
  }

  @override
  void dispose() {
    filter.removeListener(_onFilterChanged);
    super.dispose();
  }
}
