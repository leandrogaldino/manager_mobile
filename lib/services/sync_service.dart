import 'dart:developer';

import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/personcompressorcoalescent_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/productcode_service.dart';
import 'package:manager_mobile/services/service_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';

class SyncService {
  final ProductService _productService;
  final ProductCodeService _productCodeService;
  final ServiceService _serviceService;
  final CompressorService _compressorService;
  final PersonCompressorCoalescentService _personCompressorcoalescentService;
  final PersonCompressorService _personCompressorService;
  final PersonService _personService;
  final VisitScheduleService _visitScheduleService;
  final EvaluationService _evaluationService;
  final AppPreferences _appPreferences;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  SyncService({
    required ProductService productService,
    required ProductCodeService productCodeService,
    required ServiceService serviceService,
    required CompressorService compressorService,
    required PersonCompressorCoalescentService personCompressorcoalescentService,
    required PersonCompressorService personCompressorService,
    required PersonService personService,
    required VisitScheduleService visitScheduleService,
    required EvaluationService evaluationService,
    required AppPreferences appPreferences,
  })  : _productService = productService,
        _productCodeService = productCodeService,
        _serviceService = serviceService,
        _compressorService = compressorService,
        _personCompressorcoalescentService = personCompressorcoalescentService,
        _personCompressorService = personCompressorService,
        _personService = personService,
        _visitScheduleService = visitScheduleService,
        _evaluationService = evaluationService,
        _appPreferences = appPreferences;

  Future<int> runSync({bool isAuto = false}) async {
    log('Iniciando sincronização ${isAuto ? "(Automática)" : ""}...', time: DateTime.now());
    if (_isSyncing) {
      log('Sincronização já está em andamento. Abortando nova solicitação.', time: DateTime.now());
      return 0;
    }
    _isSyncing = true;
    try {
      int lastSync = await _appPreferences.lastSynchronize;
      log('Sincronizando dados desde o timestamp: $lastSync', time: DateTime.now());
      int totalCount = 0;
      log('Sincronizando Produtos...', time: DateTime.now());
      final int productsCount = await _productService.synchronize(lastSync);
      totalCount += productsCount;
      log('$productsCount Produtos sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Códigos de Produtos...', time: DateTime.now());
      final int productCodesCount = await _productCodeService.synchronize(lastSync);
      totalCount += productCodesCount;
      log('$productCodesCount Códigos de Produtos sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Serviços...', time: DateTime.now());
      final int servicesCount = await _serviceService.synchronize(lastSync);
      totalCount += servicesCount;
      log('$servicesCount Serviços sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Compressores...', time: DateTime.now());
      final int compressorsCount = await _compressorService.synchronize(lastSync);
      totalCount += compressorsCount;
      log('$compressorsCount Compressores sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Coalescentes dos Compressores', time: DateTime.now());
      final int personCompressorCoalescentCount = await _personCompressorcoalescentService.synchronize(lastSync);
      totalCount += personCompressorCoalescentCount;
      log('$personCompressorCoalescentCount Coalescentes dos Compressores sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Compressores das Pessoas...', time: DateTime.now());
      final int personCompressorCount = await _personCompressorService.synchronize(lastSync);
      totalCount += personCompressorCount;
      log('$personCompressorCount Compressores das Pessoas sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Pessoas...', time: DateTime.now());
      final int personsCount = await _personService.synchronize(lastSync);
      totalCount += personsCount;
      log('$personsCount Pessoas sincronizadas... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Agendamentos de Visita...', time: DateTime.now());
      final int visitSchedulesCount = await _visitScheduleService.synchronize(lastSync);
      totalCount += visitSchedulesCount;
      log('$visitSchedulesCount Agendamentos de Visita sincronizados... (Total: $totalCount)', time: DateTime.now());
      log('Sincronizando Avaliações...', time: DateTime.now());
      final int evaluationsCount = await _evaluationService.synchronize(lastSync);
      totalCount += evaluationsCount;
      log('$evaluationsCount Avaliações sincronizadas... (Total: $totalCount)', time: DateTime.now());
      await _appPreferences.updateLastSynchronize();
      return totalCount;
    } finally {
      _isSyncing = false;
    }
  }
}
