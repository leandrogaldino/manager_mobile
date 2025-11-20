import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/sync_controller.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomeController extends ChangeNotifier {
  final SyncController _syncController;
  final DataController _dataController;
  final FilterController _filterController;
  HomeController({
    required SyncController syncController,
    required DataController dataController,
    required FilterController filterController,
  })  : _syncController = syncController,
        _dataController = dataController,
        _filterController = filterController {
    _filterController.addListener(fetchData);
  }

  void _onFilterChanged() {
    fetchData();
  }

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;
  void _setState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  List<VisitScheduleModel> _filteredVisitSchedules = [];
  List<EvaluationModel> _filteredEvaluations = [];

  List<VisitScheduleModel> get filteredVisitSchedules => _filteredVisitSchedules;
  List<EvaluationModel> get filteredEvaluations => _filteredEvaluations;

  Future<void> fetchData() async {
    String? text = _filterController.typedCustomerOrCompressorText;
    DateTimeRange? dateRange = _filterController.selectedDateRange;
  
      _filteredVisitSchedules = _dataController.visitSchedules.toList();
      _filteredEvaluations = _dataController.evaluations.toList();
      if (text.isNotEmpty) {
        _filteredVisitSchedules = _filteredVisitSchedules.where(
          (schedule) {
            return schedule.customer.shortName.toLowerCase().contains(text) ||
                schedule.compressor.compressor.name.toLowerCase().contains(text) ||
                schedule.compressor.serialNumber.toLowerCase().contains(text) ||
                schedule.compressor.sector.toLowerCase().contains(text) ||
                schedule.technician.shortName.toLowerCase().contains(text);
          },
        ).toList();
        _filteredEvaluations = _filteredEvaluations.where(
          (evaluation) {
            return evaluation.compressor!.person.shortName.toLowerCase().contains(text) ||
                evaluation.compressor!.compressor.name.toLowerCase().contains(text) ||
                evaluation.compressor!.sector.toLowerCase().contains(text) ||
                evaluation.technicians.any((t) => t.technician.shortName.toLowerCase().contains(text));
          },
        ).toList();
      }
      if (dateRange != null) {
        if (dateRange.start.isAtSameMomentAs(dateRange.end)) {
          _filteredVisitSchedules = _filteredVisitSchedules.where((schedule) => schedule.scheduleDate.isAtSameMomentAs(dateRange.start)).toList();
          _filteredEvaluations = _filteredEvaluations.where((evaluation) => evaluation.creationDate!.isAtSameMomentAs(dateRange.start)).toList();
        } else {
          _filteredVisitSchedules = _filteredVisitSchedules.where((schedule) {
            return (schedule.scheduleDate.isAfter(dateRange.start) || schedule.scheduleDate.isAtSameMomentAs(dateRange.start)) && (schedule.scheduleDate.isBefore(dateRange.end) || schedule.scheduleDate.isAtSameMomentAs(dateRange.end));
          }).toList();
          _filteredEvaluations = _filteredEvaluations.where((evaluation) {
            return (evaluation.creationDate!.isAfter(dateRange.start) || evaluation.creationDate!.isAtSameMomentAs(dateRange.start)) && (evaluation.creationDate!.isBefore(dateRange.end) || evaluation.creationDate!.isAtSameMomentAs(dateRange.end));
          }).toList();
        }
      }

  }

  Future<void> synchronize(bool showLoading, bool hideFilterButton) async {
    try {
      if (showLoading) {
        _setState(HomeStateLoading());
      }
      if (hideFilterButton) {
        _filterController.setShowFilterButton(!hideFilterButton);
      }
      if (_syncController.isSyncing) {
        log('Sincronização já está em andamento');
        return;
      }
      int totalCount = await _syncController.runSync();

      //Se houve qualquer sincronizacao, atualizar
      if (totalCount > 0 || _dataController.compressors.isEmpty) await _dataController.fetchCompressors();
      if (totalCount > 0 || _dataController.technicians.isEmpty) await _dataController.fetchTechnicians();
      if (totalCount > 0 || _dataController.evaluations.isEmpty) await _dataController.fetchEvaluations();
      if (totalCount > 0 || _dataController.visitSchedules.isEmpty) await _dataController.fetchVisitSchedules();

      await fetchData();

      if (_state is! HomeStateError) {
        _state = HomeStateSuccess(filteredVisitSchedules, filteredEvaluations);
      }
      log('Sincronização concluída com sucesso');
      _setState(HomeStateSuccess(filteredVisitSchedules, filteredEvaluations));
      _filterController.setShowFilterButton(true);
    } catch (e) {
      _setState(HomeStateError(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _filterController.removeListener(_onFilterChanged);
    super.dispose();
  }
}
