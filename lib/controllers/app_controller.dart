import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';

class AppController extends ChangeNotifier {
  final AppPreferences _appPreferences;

  AppController({
    required appPreferences,
  }) : _appPreferences = appPreferences;

  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

  Future<void> changeTheme(ThemeMode mode) async {
    themeMode.value = mode;
    await _saveTheme(mode);
  }

  Future<void> loadTheme() async {
    try {
      themeMode.value = await _appPreferences.themeMode;
    } catch (e) {
      throw Exception('Erro ao carregar o tema: $e');
    }
  }

  Future<void> _saveTheme(ThemeMode theme) async {
    await _appPreferences.setThemeMode(theme);
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
}
