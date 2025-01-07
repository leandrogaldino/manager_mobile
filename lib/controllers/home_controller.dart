import 'package:flutter/foundation.dart';
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

  Future<void> fetchData() async {
    try {
      _schedules = await _scheduleService.getAll();
      _evaluations = await _evaluationService.getAll();
      _state = HomeStateSuccess(schedules, evaluations);
    } on Exception catch (e) {
      _state = HomeStateError(e.toString());
    }
    notifyListeners();
  }
}
