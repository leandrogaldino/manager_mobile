import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/schedule_service.dart';

class AppController extends ChangeNotifier {
  final LocalDatabase _localDatabase;
  final CoalescentService _coalescentService;
  final CompressorService _compressorService;
  final PersonService _personService;
  final EvaluationService _evaluationService;
  final ScheduleService _scheduleService;

  AppController({
    required localDatabase,
    required coalescentService,
    required compressorService,
    required personService,
    required evaluationService,
    required scheduleService,
  })  : _localDatabase = localDatabase,
        _coalescentService = coalescentService,
        _compressorService = compressorService,
        _personService = personService,
        _evaluationService = evaluationService,
        _scheduleService = scheduleService;

  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await _saveTheme(mode);
  }

  Future<void> loadTheme() async {
    try {
      final result = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['theme']);
      themeMode.value = _parseThemeMode(result[0]['value'] as String? ?? 'ThemeMode.system');
    } catch (e) {
      throw Exception('Erro ao carregar o tema: $e');
    }
  }

  Future<void> _saveTheme(ThemeMode theme) async {
    _localDatabase.update('preferences', {'value': theme.toString()}, where: 'key = ?', whereArgs: ['theme']);
  }

  String getCurrentThemeModeName() {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      default:
        return 'Sistema';
    }
  }

  ThemeMode getThemeMode(String themeString) {
    switch (themeString) {
      case 'Claro':
        return ThemeMode.light;
      case 'Escuro':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  Future<SyncronizeResultModel> syncronize() async {
    int downloaded = 0;
    int uploaded = 0;
    late SyncronizeResultModel syncResult;

    await _localDatabase.update('preferences', {'value': 1}, where: 'key = ?', whereArgs: ['syncronizing']);

    final lastSyncResult = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());

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

    _localDatabase.update('preferences', {'value': DateTime.now().millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['lastsync']);

    await _localDatabase.update('preferences', {'value': 0}, where: 'key = ?', whereArgs: ['syncronizing']);
    notifyListeners();
    return SyncronizeResultModel(uploaded: uploaded, downloaded: downloaded);
  }
}
