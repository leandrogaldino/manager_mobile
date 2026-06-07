import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/states/app_state.dart';
import 'package:path_provider/path_provider.dart';

class AppController extends ChangeNotifier {
  final AppPreferences _appPreferences;

  AppController({
    required AppPreferences appPreferences,
  }) : _appPreferences = appPreferences;

  AppState _state = AppStateInitial();
  AppState get state => _state;

  void _setState(AppState newState) {
    _state = newState;
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> changeTheme(ThemeMode themeMode) async {
    try {
      _themeMode = themeMode;
      await _appPreferences.setThemeMode(themeMode);
      _setState(AppStateSuccess());
    } on Exception catch (e) {
      _setState(AppStateError(e.toString()));
    }
  }

  Future<void> loadTheme() async {
    try {
      _themeMode = await _appPreferences.themeMode;
      _setState(AppStateSuccess());
    } catch (e) {
      _setState(AppStateError(e.toString()));
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
        } catch (e, s) {
          String message = 'Erro ao excluir arquivo temporário.';
          log(message, time: DateTime.now(), error: e, stackTrace: s);
        }
      }
    }
  }
}
