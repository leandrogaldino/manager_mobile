import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class AppController {
  final LocalDatabase _localDatabase;

  AppController({required LocalDatabase localDatabase}) : _localDatabase = localDatabase;

  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await _saveTheme(mode);
  }

  Future<void> loadTheme() async {
    try {
      final result = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['theme']);
      themeMode.value = parseThemeMode(result[0]['value'] as String? ?? 'ThemeMode.system');
    } catch (e) {
      throw Exception('Erro ao carregar o tema: $e');
    }
  }

  Future<void> _saveTheme(ThemeMode theme) async {
    _localDatabase.update('preferences', {'theme': theme.toString()});
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

  ThemeMode parseThemeMode(String themeString) {
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
}
