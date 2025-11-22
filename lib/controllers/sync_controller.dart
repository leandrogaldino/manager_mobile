import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/personcompressorcoalescent_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/productcode_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';
import 'package:manager_mobile/services/service_service.dart';

class SyncController extends ChangeNotifier {
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

  SyncController({
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
    required DataController personController,
    required FilterController filterController,
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
  bool get isSyncing => _isSyncing;
  void _setSyncing(bool value) {
    _isSyncing = value;
    notifyListeners();
  }

  Future<int> runSync() async {
    _setSyncing(true);
    try {
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
      int visitScheduleCount = await _visitScheduleService.synchronize(lastSync);
      log('Sincronizando Avaliações');
      int evaluationCount = await _evaluationService.synchronize(lastSync);
      await _appPreferences.updateLastSynchronize();
      int totalCount = countProduct + countProductCode + countService + countCompressor + countPersonCompressorCoalescent + countPersonCompressor + countPerson + visitScheduleCount + evaluationCount;
      notifyListeners();
      return totalCount;
    } catch (e) {
      rethrow;
    } finally {
      _setSyncing(false);
    }
  }
}
