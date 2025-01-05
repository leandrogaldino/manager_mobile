// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/person_service.dart';

class AppController {
  final LocalDatabase _localDatabase;
  final CoalescentService _coalescentService;
  final CompressorService _compressorService;
  final PersonService _personService;

  AppController({
    required localDatabase,
    required coalescentService,
    required compressorService,
    required personService,
  })  : _localDatabase = localDatabase,
        _coalescentService = coalescentService,
        _compressorService = compressorService,
        _personService = personService;

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
    int count = 0;
    count = await _coalescentService.syncronize().then((r) => r.downloaded);
    count += await _compressorService.syncronize().then((r) => r.downloaded);
    count += await _personService.syncronize().then((r) => r.downloaded);
    //TODO: Incluir sincronizações quando forem criadas
    // _localDatabase.update('preferences', {'value': DateTime.now().millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['lastsync']);
    return SyncronizeResultModel(uploaded: 0, downloaded: count);
  }
}
