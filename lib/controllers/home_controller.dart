import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/personcompressorcoalescent_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/productcode_service.dart';
import 'package:manager_mobile/services/schedule_service.dart';
import 'package:manager_mobile/services/service_service.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomeController extends ChangeNotifier {
  final ProductService _productService;
  final ProductCodeService _productCodeService;
  final ServiceService _serviceService;
  final CompressorService _compressorService;
  final PersonCompressorCoalescentService _personCompressorcoalescentService;
  final PersonCompressorService _personCompressorService;
  final PersonService _personService;
  final ScheduleService _scheduleService;
  final EvaluationService _evaluationService;
  final AppPreferences _appPreferences;
  final DataController _personController;

  HomeController({
    required ProductService productService,
    required ProductCodeService productCodeService,
    required ServiceService serviceService,
    required CompressorService compressorService,
    required PersonCompressorCoalescentService personCompressorcoalescentService,
    required PersonCompressorService personCompressorService,
    required PersonService personService,
    required ScheduleService scheduleService,
    required EvaluationService evaluationService,
    required AppPreferences appPreferences,
    required DataController customerController,
  })  : _productService = productService,
        _productCodeService = productCodeService,
        _serviceService = serviceService,
        _compressorService = compressorService,
        _personCompressorcoalescentService = personCompressorcoalescentService,
        _personCompressorService = personCompressorService,
        _personService = personService,
        _scheduleService = scheduleService,
        _evaluationService = evaluationService,
        _appPreferences = appPreferences,
        _personController = customerController;

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;
  void _setState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  List<VisitScheduleModel> _schedules = [];
  List<EvaluationModel> _evaluations = [];

  List<VisitScheduleModel> get schedules => _schedules;
  List<EvaluationModel> get evaluations => _evaluations;

  String _customerOrCompressor = '';
  String get customerOrCompressor => _customerOrCompressor;
  Future<void> setCustomerOrCompressorFilter(String query) async {
    _customerOrCompressor = query;
    await fetchData(customerOrCompressor: customerOrCompressor, dateRange: dateRange);
  }

  DateTimeRange? _dateRange;
  DateTimeRange? get dateRange => _dateRange;
  Future<void> setDateRangeFilter(DateTimeRange? query) async {
    _dateRange = query;
    await fetchData(customerOrCompressor: customerOrCompressor, dateRange: dateRange);
  }

  int get firstYear {
    if (schedules.isEmpty || evaluations.isEmpty) return 0;
    int minScheduleYear = schedules.map((s) => s.creationDate.year).reduce((a, b) => a < b ? a : b);
    int minEvaluationYear = evaluations.map((e) => e.creationDate!.year).reduce((a, b) => a < b ? a : b);
    return minScheduleYear < minEvaluationYear ? minScheduleYear : minEvaluationYear;
  }

  int get lastYear {
    if (schedules.isEmpty || evaluations.isEmpty) return 0;
    int maxScheduleYear = schedules.map((s) => s.creationDate.year).reduce((a, b) => a > b ? a : b);
    int maxEvaluationYear = evaluations.map((e) => e.creationDate!.year).reduce((a, b) => a > b ? a : b);
    return maxScheduleYear > maxEvaluationYear ? maxScheduleYear : maxEvaluationYear;
  }

  Future<void> fetchData({String? customerOrCompressor, DateTimeRange? dateRange}) async {
    try {
      _schedules = await _scheduleService.getVisibles();
      _evaluations = await _evaluationService.getVisibles();
      if (customerOrCompressor != null && customerOrCompressor.isNotEmpty) {
        _schedules = _schedules.where(
          (schedule) {
            return schedule.customer.shortName.toLowerCase().contains(customerOrCompressor) ||
                schedule.compressor.compressor.name.toLowerCase().contains(customerOrCompressor) ||
                schedule.compressor.serialNumber.toLowerCase().contains(customerOrCompressor) ||
                schedule.compressor.sector.toLowerCase().contains(customerOrCompressor);
          },
        ).toList();
        _evaluations = _evaluations.where(
          (evaluation) {
            return evaluation.compressor!.person.shortName.toLowerCase().contains(customerOrCompressor) || evaluation.compressor!.compressor.name.toLowerCase().contains(customerOrCompressor) || evaluation.compressor!.sector.toLowerCase().contains(customerOrCompressor);
          },
        ).toList();
      }
      if (dateRange != null) {
        if (dateRange.start.isAtSameMomentAs(dateRange.end)) {
          _schedules = _schedules.where((schedule) => schedule.scheduleDate.isAtSameMomentAs(dateRange.start)).toList();
          _evaluations = _evaluations.where((evaluation) => evaluation.creationDate!.isAtSameMomentAs(dateRange.start)).toList();
        } else {
          _schedules = _schedules.where((schedule) {
            return (schedule.scheduleDate.isAfter(dateRange.start) || schedule.scheduleDate.isAtSameMomentAs(dateRange.start)) && (schedule.scheduleDate.isBefore(dateRange.end) || schedule.scheduleDate.isAtSameMomentAs(dateRange.end));
          }).toList();
          _evaluations = _evaluations.where((evaluation) {
            return (evaluation.creationDate!.isAfter(dateRange.start) || evaluation.creationDate!.isAtSameMomentAs(dateRange.start)) && (evaluation.creationDate!.isBefore(dateRange.end) || evaluation.creationDate!.isAtSameMomentAs(dateRange.end));
          }).toList();
        }
      }
      _state = HomeStateSuccess(schedules, evaluations);
    } on Exception catch (e) {
      _state = HomeStateError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> synchronize(bool showLoading) async {
    try {
      if (showLoading) {
        _setState(HomeStateLoading());
      }
      if (await _appPreferences.synchronizing) {
        log('Sincronização já está em andamento');
        return;
      }
      await _appPreferences.setSynchronizing(true);
      int lastSync = await _appPreferences.lastSynchronize;
      log('Sincronizando Produtos');
      int countProduct = await _productService.synchronize(lastSync);
      log('Sincronizando Códigos de Produtos');
      int countProductCode = await _productCodeService.synchronize(lastSync);
      log('Sincronizando Serviços');
      int countService = await _serviceService.synchronize(lastSync);
      log('Sincronizando Compressores');
      int countCompressor = await _compressorService.synchronize(lastSync);
      log('Sincronizando Coalescentes dos Compressores da Pessoa');
      int countPersonCompressorCoalescent = await _personCompressorcoalescentService.synchronize(lastSync);
      log('Sincronizando Compressores da Pessoa');
      int countPersonCompressor = await _personCompressorService.synchronize(lastSync);
      log('Sincronizando Pessoas');
      int countPerson = await _personService.synchronize(lastSync);
      log('Sincronizando Agendamentos');
      await _scheduleService.synchronize(lastSync);
      log('Sincronizando Avaliações');
      await _evaluationService.synchronize(lastSync);
      await _appPreferences.updateLastSynchronize();
      await _appPreferences.setSynchronizing(false);

      int totalCount = countProduct + countProductCode + countService + countCompressor + countPersonCompressorCoalescent + countPersonCompressor + countPerson;
      //Se houve qualquer sincronizacao, atualizar compressores
      if (totalCount > 0 || _personController.compressors.isEmpty) await _personController.fetchCompressors();

      //Se houve alteracao em sincronizacao, atualizar tecnicos
      if (countPerson > 0 || _personController.technicians.isEmpty) await _personController.fetchTechnicians();

      await fetchData(customerOrCompressor: customerOrCompressor, dateRange: dateRange);
      if (_state is! HomeStateError) {
        _state = HomeStateSuccess(schedules, evaluations);
      }
      log('Sincronização concluída com sucesso');
      _setState(HomeStateSuccess(schedules, evaluations));
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
}
