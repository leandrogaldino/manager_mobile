import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/product_model.dart';
import 'package:manager_mobile/models/service_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/service_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';

class DataService {
  final VisitScheduleService _visitScheduleService;
  final EvaluationService _evaluationService;
  final PersonService _personService;
  final PersonCompressorService _compressorService;
  final ProductService _productService;
  final ServiceService _serviceService;

  DataService({
    required VisitScheduleService visitScheduleService,
    required EvaluationService evaluationService,
    required PersonService personService,
    required PersonCompressorService compressorService,
    required ProductService productService,
    required ServiceService serviceService,
  })  : _visitScheduleService = visitScheduleService,
        _evaluationService = evaluationService,
        _personService = personService,
        _compressorService = compressorService,
        _productService = productService,
        _serviceService = serviceService;

  List<VisitScheduleModel> _visitSchedules = [];
  List<VisitScheduleModel> get visitSchedules => _visitSchedules;

  List<EvaluationModel> _evaluations = [];
  List<EvaluationModel> get evaluations => _evaluations;

  List<PersonCompressorModel> _compressors = [];
  List<PersonCompressorModel> get compressors => _compressors;

  List<PersonModel> _technicians = [];
  List<PersonModel> get technicians => _technicians;

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  Future<void> fetchVisitSchedules() async {
    _visitSchedules = await _visitScheduleService.getVisibles();
  }

  Future<void> fetchEvaluations() async {
    _evaluations = await _evaluationService.getVisibles();
  }

  Future<void> fetchCompressors() async {
    _compressors = await _compressorService.getVisibles();
  }

  Future<void> fetchTechnicians() async {
    _technicians = await _personService.getTechnicians();
    _technicians = _technicians.where((t) => t.visible).toList();
    _technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
  }

  Future<void> fetchProducts() async {
    _products = await _productService.getVisibles();
  }

  Future<void> fetchServices() async {
    _services = await _serviceService.getVisibles();
  }

  Future<void> fetchAllIfNeeded(bool force) async {
    if (force || _visitSchedules.isEmpty) await fetchVisitSchedules();
    if (force || _evaluations.isEmpty) await fetchEvaluations();
    if (force || _compressors.isEmpty) await fetchCompressors();
    if (force || _technicians.isEmpty) await fetchTechnicians();
    if (force || _products.isEmpty) await fetchProducts();
    if (force || _services.isEmpty) await fetchServices();
  }

  DateTime? get firstEvaluationOrVisitScheduleDate {
    final dates = [
      ..._visitSchedules.map((e) => e.scheduleDate),
      ..._evaluations.map((e) => e.creationDate),
    ];

    if (dates.isEmpty) return null;

    dates.sort();
    return dates.first;
  }

  DateTime? get lastEvaluationOrVisitScheduleDate {
    final dates = [
      ..._visitSchedules.map((e) => e.scheduleDate),
      ..._evaluations.map((e) => e.creationDate),
    ];

    if (dates.isEmpty) return null;

    dates.sort();
    return dates.last;
  }
}
