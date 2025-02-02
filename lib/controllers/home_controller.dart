import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/schedule_service.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required CoalescentService coalescentService,
    required CompressorService compressorService,
    required PersonService personService,
    required ScheduleService scheduleService,
    required EvaluationService evaluationService,
    required AppPreferences appPreferences,
  })  : _coalescentService = coalescentService,
        _compressorService = compressorService,
        _personService = personService,
        _scheduleService = scheduleService,
        _evaluationService = evaluationService,
        _appPreferences = appPreferences;

  final CoalescentService _coalescentService;
  final CompressorService _compressorService;
  final PersonService _personService;
  final ScheduleService _scheduleService;
  final EvaluationService _evaluationService;
  final AppPreferences _appPreferences;

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  List<ScheduleModel> _schedules = [];
  List<EvaluationModel> _evaluations = [];

  List<ScheduleModel> get schedules => _schedules;
  List<EvaluationModel> get evaluations => _evaluations;

  //Se em algum momento eu precisar manter os filtros, terei que guardar o valor deles em variaveis externas.
  Future<void> fetchData({String? customerOrCompressor, DateTimeRange? dateRange}) async {
    try {
      _schedules = await _scheduleService.getAll();
      _evaluations = await _evaluationService.getAll();

      if (customerOrCompressor != null && customerOrCompressor.isNotEmpty) {
        _schedules = _schedules.where(
          (schedule) {
            return schedule.customer.shortName.toLowerCase().contains(customerOrCompressor) || schedule.compressor.compressorName.toLowerCase().contains(customerOrCompressor) || schedule.compressor.serialNumber.toLowerCase().contains(customerOrCompressor);
          },
        ).toList();
        _evaluations = _evaluations.where(
          (evaluation) {
            return evaluation.customer!.shortName.toLowerCase().contains(customerOrCompressor) || evaluation.compressor!.compressorName.toLowerCase().contains(customerOrCompressor) || evaluation.compressor!.serialNumber.toLowerCase().contains(customerOrCompressor);
          },
        ).toList();
      }
      if (dateRange != null) {
        if (dateRange.start.isAtSameMomentAs(dateRange.end)) {
          _schedules = _schedules.where((schedule) => schedule.visitDate.isAtSameMomentAs(dateRange.start)).toList();
          _evaluations = _evaluations.where((evaluation) => evaluation.creationDate.isAtSameMomentAs(dateRange.start)).toList();
        } else {
          _schedules = _schedules.where((schedule) {
            return (schedule.visitDate.isAfter(dateRange.start) || schedule.visitDate.isAtSameMomentAs(dateRange.start)) && (schedule.visitDate.isBefore(dateRange.end) || schedule.visitDate.isAtSameMomentAs(dateRange.end));
          }).toList();
          _evaluations = _evaluations.where((evaluation) {
            return (evaluation.creationDate.isAfter(dateRange.start) || evaluation.creationDate.isAtSameMomentAs(dateRange.start)) && (evaluation.creationDate.isBefore(dateRange.end) || evaluation.creationDate.isAtSameMomentAs(dateRange.end));
          }).toList();
        }
      }

      _state = HomeStateSuccess(schedules, evaluations);
    } on Exception catch (e) {
      _state = HomeStateError(e.toString());
    }
    notifyListeners();
  }

  Future<SyncronizeResultModel> syncronize() async {
    int downloaded = 0;
    int uploaded = 0;
    late SyncronizeResultModel syncResult;

    await _appPreferences.setSynchronizing(true);
    int lastSync = await _appPreferences.lastSynchronize;

    log('Sincronizando Coalescentes');
    syncResult = await _coalescentService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    log('Sincronizando Compressores');
    syncResult = await _compressorService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    log('Sincronizando Pessoas');
    syncResult = await _personService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    log('Sincronizando Agendamentos');
    syncResult = await _scheduleService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    log('Sincronizando Avaliações');
    syncResult = await _evaluationService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    await _appPreferences.updateLastSynchronize();
    await _appPreferences.setSynchronizing(false);

    notifyListeners();
    return SyncronizeResultModel(uploaded: uploaded, downloaded: downloaded);
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
