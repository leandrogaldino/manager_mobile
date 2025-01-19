import 'package:flutter/material.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/schedule_service.dart';
import 'package:manager_mobile/states/home_state.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required ScheduleService scheduleService,
    required EvaluationService evaluationService,
  })  : _scheduleService = scheduleService,
        _evaluationService = evaluationService;

  HomeState _state = HomeStateInitial();
  HomeState get state => _state;

  final ScheduleService _scheduleService;
  final EvaluationService _evaluationService;

  List<ScheduleModel> _schedules = [];
  List<EvaluationModel> _evaluations = [];

  List<ScheduleModel> get schedules => _schedules;
  List<EvaluationModel> get evaluations => _evaluations;

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
            return evaluation.customer.shortName.toLowerCase().contains(customerOrCompressor) || evaluation.compressor.compressorName.toLowerCase().contains(customerOrCompressor) || evaluation.compressor.serialNumber.toLowerCase().contains(customerOrCompressor);
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

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
