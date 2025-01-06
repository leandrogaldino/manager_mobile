import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';

class AppController {
  final LocalDatabase _localDatabase;
  final CoalescentService _coalescentService;
  final CompressorService _compressorService;
  final PersonService _personService;
  final EvaluationService _evaluationService;

  AppController({
    required localDatabase,
    required coalescentService,
    required compressorService,
    required personService,
    required evaluationService,
  })  : _localDatabase = localDatabase,
        _coalescentService = coalescentService,
        _compressorService = compressorService,
        _personService = personService,
        _evaluationService = evaluationService;

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

    syncResult = await _coalescentService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    syncResult = await _compressorService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    syncResult = await _personService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    syncResult = await _evaluationService.syncronize(lastSync);
    downloaded += syncResult.downloaded;
    uploaded += syncResult.uploaded;

    _localDatabase.update('preferences', {'value': DateTime.now().millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['lastsync']);

    await _localDatabase.update('preferences', {'value': 0}, where: 'key = ?', whereArgs: ['syncronizing']);
    return SyncronizeResultModel(uploaded: uploaded, downloaded: downloaded);
  }
}
