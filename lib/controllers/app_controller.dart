import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:path_provider/path_provider.dart';

class AppController extends ChangeNotifier {
  final AppPreferences _appPreferences;

  AppController({
    required appPreferences,
  }) : _appPreferences = appPreferences;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> changeTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _appPreferences.setThemeMode(themeMode);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    try {
      _themeMode = await _appPreferences.themeMode;
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao carregar o tema: $e');
    }
  }

  String getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
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

  Future<void> clearOldTemporaryFiles() async {
    final tempDir = await getTemporaryDirectory();
    final files = tempDir.listSync();

    for (var fileOrDir in files) {
      if (fileOrDir is File) {
        try {
          final lastModified = await fileOrDir.lastModified();
          final now = DateTime.now();
          if (now.difference(lastModified).inHours > 24) {
            await fileOrDir.delete();
          }
        } catch (e) {
          log("Erro ao excluir arquivo temporário: $e");
        }
      }
    }
  }
}
