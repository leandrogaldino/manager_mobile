import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class AppPreferences {
  final LocalDatabase _database;

  AppPreferences({required LocalDatabase database}) : _database = database;

  Future<void> setThemeMode(ThemeMode theme) async {
    await _database.update('preferences', {'value': theme.toString()}, where: 'key = ?', whereArgs: ['theme']);
  }

  Future<void> updateLastSynchronize() async {
    await _database.update('preferences', {'value': DateTime.now().millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['lastsync']);
  }

  Future<int> get lastSynchronize async {
    final lastSyncResult = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());
    return lastSync;
  }

  Future<void> setSynchronizing(bool synchronizing) async {
    await _database.update('preferences', {'value': synchronizing == false ? 0 : 1}, where: 'key = ?', whereArgs: ['synchronizing']);
  }

  Future<void> setLoggedTechnicianId(int id) async {
    await _database.update('preferences', {'value': id}, where: 'key = ?', whereArgs: ['loggedtechnicianid']);
  }

  Future<int> get loggedTechnicianId async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianid']);
    return int.parse(data[0]['value'].toString());
  }

  Future<ThemeMode> get themeMode async {
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
