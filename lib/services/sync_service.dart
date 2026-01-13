import 'dart:developer';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
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

  bool _synchronizing = false;
  bool get synchronizing => _synchronizing;

  Future<bool> runSync({bool isAuto = false}) async {
    _synchronizing = true;

    log('${isAuto ? "(Auto) " : ""}Iniciando sincronização.', time: DateTimeHelper.now());

    final lastLock = await _appPreferences.syncLockTime;
    if (isSyncLocked(lastLock)) {
      log('${isAuto ? "(Auto) " : ""}Sincronização já está em andamento (lock ativo). Abortando.', time: DateTimeHelper.now());
      return false;
    }

    // Ativa lock imediatamente
    await _appPreferences.setSyncLockTime(DateTimeHelper.now());

    // Inicia o timer que manterá o lock renovado durante toda a sync
    await RefreshSyncLockTimer.start();
    log('${isAuto ? "(Auto) " : ""}==============RefreshSyncLockTimer iniciado!===================', time: DateTimeHelper.now());

    try {
      _appPreferences.setIgnoreLastSynchronize(false);
      final int lastSync = await _appPreferences.lastSynchronize;
      int totalCount = 0;
      bool newVisitScheduleOrEvaluation = false;

      // --- PRODUTOS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Produtos...', time: DateTimeHelper.now());
      final int productsCount = await _productService.synchronize(lastSync);
      totalCount += productsCount;

      // --- CODIGOS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Códigos de Produtos...', time: DateTimeHelper.now());
      final int productCodesCount = await _productCodeService.synchronize(lastSync);
      totalCount += productCodesCount;

      // --- SERVIÇOS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Serviços...', time: DateTimeHelper.now());
      final int servicesCount = await _serviceService.synchronize(lastSync);
      totalCount += servicesCount;

      // --- COMPRESSORES ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Compressores...', time: DateTimeHelper.now());
      final int compressorsCount = await _compressorService.synchronize(lastSync);
      totalCount += compressorsCount;

      // --- COALESCENTES ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Coalescentes dos Compressores...', time: DateTimeHelper.now());
      final int personCompressorCoalescentCount = await _personCompressorcoalescentService.synchronize(lastSync);
      totalCount += personCompressorCoalescentCount;

      // --- COMPRESSORES DAS PESSOAS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Compressores das Pessoas...', time: DateTimeHelper.now());
      final int personCompressorCount = await _personCompressorService.synchronize(lastSync);
      totalCount += personCompressorCount;

      // --- PESSOAS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Pessoas...', time: DateTimeHelper.now());
      final int personsCount = await _personService.synchronize(lastSync);
      totalCount += personsCount;

      // --- AGENDAMENTOS ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Agendamentos de Visita...', time: DateTimeHelper.now());
      final int visitSchedulesCount = await _visitScheduleService.synchronize(lastSync);
      totalCount += visitSchedulesCount;

      newVisitScheduleOrEvaluation = visitSchedulesCount > 0;

      // --- AVALIAÇÕES ---
      log('${isAuto ? "(Auto) " : ""}Sincronizando Avaliações...', time: DateTimeHelper.now());
      final int evaluationsCount = await _evaluationService.synchronize(lastSync);
      totalCount += evaluationsCount;
      
      newVisitScheduleOrEvaluation = newVisitScheduleOrEvaluation == true ? newVisitScheduleOrEvaluation : evaluationsCount > 0;

      log('${isAuto ? "(Auto) " : ""}Sincronização concluída. Total atualizado: $totalCount', time: DateTimeHelper.now());

      // Fim!
      if (await _appPreferences.ignoreLastSynchronize) {
        log('${isAuto ? "(Auto) " : ""}Ignorando atualização do timestamp de sincronização conforme preferência.', time: DateTimeHelper.now());
        return newVisitScheduleOrEvaluation;
      }
      await _appPreferences.setLastSynchronize();
      await _appPreferences.setSyncCount((await _appPreferences.syncCount) + 1);
      _synchronizing = false;
      return newVisitScheduleOrEvaluation;
    } catch (e, s) {
      log('${isAuto ? "(Auto) " : ""}Erro durante a sincronização: $e', error: e, stackTrace: s, time: DateTimeHelper.now());
      rethrow;
    } finally {
      // Para de renovar o lock
      await RefreshSyncLockTimer.stop();
      log('${isAuto ? "(Auto) " : ""}==============RefreshSyncLockTimer parado!===================', time: DateTimeHelper.now());
      // Remove lock manualmente (evita manter bloqueado por timeout)
      await _appPreferences.setSyncLockTime(null);
    }
  }

  bool isSyncLocked(DateTime? lastSyncLock) {
    if (lastSyncLock == null) return false;
    final now = DateTimeHelper.now();
    final diff = now.difference(lastSyncLock).inSeconds;
    return diff < 120;
  }

  Future<bool> get firstSyncSuccessfulDone async => (await _appPreferences.syncCount) > 0;
}
