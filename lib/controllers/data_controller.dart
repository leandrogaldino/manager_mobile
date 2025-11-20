import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';

class DataController {
  final VisitScheduleService _visitScheduleService;
  final EvaluationService _evaluationService;
  final PersonService _personService;
  final PersonCompressorService _compressorService;
  DataController({
    required VisitScheduleService visitScheduleService,
    required EvaluationService evaluationService,
    required PersonService personService,
    required PersonCompressorService compressorService,
  })  : _visitScheduleService = visitScheduleService,
        _evaluationService = evaluationService,
        _personService = personService,
        _compressorService = compressorService;

  List<VisitScheduleModel> _visitSchedules = [];
  List<VisitScheduleModel> get visitSchedules => _visitSchedules;
  Future<void> fetchVisitSchedules() async {
    _visitSchedules = await _visitScheduleService.getVisibles();
  }

  List<EvaluationModel> _evaluations = [];
  List<EvaluationModel> get evaluations => _evaluations;
  Future<void> fetchEvaluations() async {
    _evaluations = await _evaluationService.getVisibles();
  }

  List<PersonCompressorModel> _compressors = [];
  List<PersonCompressorModel> get compressors => _compressors;
  Future<void> fetchCompressors() async {
    _compressors = await _compressorService.getVisibles();
  }

  List<PersonModel> _technicians = [];

  List<PersonModel> get technicians => _technicians;
  Future<void> fetchTechnicians() async {
    _technicians = await _personService.getTechnicians();
    _technicians = _technicians.where((person) => person.visible == true).toList();
    technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
  }


  DateTime? get firstDate {
  final dates = [
    ..._visitSchedules.map((e) => e.scheduleDate),
    ..._evaluations.map((e) => e.creationDate),
  ];

  if (dates.isEmpty) return null;

  dates.sort();
  return dates.first;
}

DateTime? get lastDate {
  final dates = [
    ..._visitSchedules.map((e) => e.scheduleDate),
    ..._evaluations.map((e) => e.creationDate),
  ];

  if (dates.isEmpty) return null;

  dates.sort();
  return dates.last;
}
}
