import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class AppPreferences {
  final LocalDatabase _database;

  AppPreferences({required LocalDatabase database}) : _database = database;

  Future<void> setLoggedTechnicianId(int id) async {
    await _database.update('preferences', {'value': id}, where: 'key = ?', whereArgs: ['loggedtechnicianid']);
  }

  Future<int> get getLoggedTechnicianId async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianid']);
    return int.parse(data[0]['value'].toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final result = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['theme']);
    return _parseThemeMode(result[0]['value'] as String? ?? 'ThemeMode.system');
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
}
