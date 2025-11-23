import 'dart:developer';

import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/timers/refresh_sync_lock_timer.dart';
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
    log('${isAuto ? "(Workmanager) " : ""}Iniciando sincronização.', time: DateTime.now());

    final lastLock = await _appPreferences.lastSyncLock;
    if (isSyncLocked(lastLock)) {
      log('${isAuto ? "(Workmanager) " : ""}Sincronização já está em andamento (lock ativo). Abortando.', time: DateTime.now());
      return 0;
    }

    // Ativa lock imediatamente
    await _appPreferences.setLastSyncLock(DateTime.now());

    // Inicia o timer que manterá o lock renovado durante toda a sync
    await RefreshSyncLockTimer.start();

    try {
      final int lastSync = await _appPreferences.lastSynchronize;
      int totalCount = 0;

      // --- PRODUTOS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Produtos...', time: DateTime.now());
      final int productsCount = await _productService.synchronize(lastSync);
      totalCount += productsCount;

      // --- CODIGOS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Códigos de Produtos...', time: DateTime.now());
      final int productCodesCount = await _productCodeService.synchronize(lastSync);
      totalCount += productCodesCount;

      // --- SERVIÇOS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Serviços...', time: DateTime.now());
      final int servicesCount = await _serviceService.synchronize(lastSync);
      totalCount += servicesCount;

      // --- COMPRESSORES ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Compressores...', time: DateTime.now());
      final int compressorsCount = await _compressorService.synchronize(lastSync);
      totalCount += compressorsCount;

      // --- COALESCENTES ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Coalescentes dos Compressores...', time: DateTime.now());
      final int personCompressorCoalescentCount = await _personCompressorcoalescentService.synchronize(lastSync);
      totalCount += personCompressorCoalescentCount;

      // --- COMPRESSORES DAS PESSOAS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Compressores das Pessoas...', time: DateTime.now());
      final int personCompressorCount = await _personCompressorService.synchronize(lastSync);
      totalCount += personCompressorCount;

      // --- PESSOAS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Pessoas...', time: DateTime.now());
      final int personsCount = await _personService.synchronize(lastSync);
      totalCount += personsCount;

      // --- AGENDAMENTOS ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Agendamentos de Visita...', time: DateTime.now());
      final int visitSchedulesCount = await _visitScheduleService.synchronize(lastSync);
      totalCount += visitSchedulesCount;

      // --- AVALIAÇÕES ---
      log('${isAuto ? "(Workmanager) " : ""}Sincronizando Avaliações...', time: DateTime.now());
      final int evaluationsCount = await _evaluationService.synchronize(lastSync);
      totalCount += evaluationsCount;

      // Fim!
      await _appPreferences.updateLastSynchronize();

      log('${isAuto ? "(Workmanager) " : ""}Sincronização concluída. Total atualizado: $totalCount', time: DateTime.now());

      return totalCount;
    } catch (e, s) {
      log('${isAuto ? "(Workmanager) " : ""}Erro durante a sincronização: $e', error: e, stackTrace: s, time: DateTime.now());
      rethrow;
    } finally {
      // Para de renovar o lock
      await RefreshSyncLockTimer.stop();

      // Remove lock manualmente (evita manter bloqueado por timeout)
      await _appPreferences.setLastSyncLock(null);
    }
  }

  bool isSyncLocked(DateTime? lastSyncLock) {
    if (lastSyncLock == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastSyncLock).inSeconds;
    return diff < 15;
  }
}
