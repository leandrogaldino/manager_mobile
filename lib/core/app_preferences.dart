import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/local_database.dart';

class AppPreferences {
  final LocalDatabase _database;

  AppPreferences({required LocalDatabase database}) : _database = database;

  Future<void> setThemeMode(ThemeMode theme) async {
    await _database.update('preferences', {'value': theme.toString()}, where: 'key = ?', whereArgs: ['theme']);
  }

  Future<void> setLastSynchronize() async {
    await _database.update('preferences', {'value': DateTime.now().millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['lastsync']);
  }

  Future<int> get lastSynchronize async {
    final lastSyncResult = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());
    return lastSync;
  }

  Future<void> setIgnoreLastSynchronize(bool ignore) async {
    await _database.update('preferences', {'value': ignore.toString() }, where: 'key = ?', whereArgs: ['ignorelastsynchronize']);
  }

  Future<bool> get ignoreLastSynchronize async {
    final result = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['ignorelastsynchronize']);
    bool ignore = bool.parse(result[0]['value'].toString());
    return ignore;
  }

  Future<DateTime?> get syncLockTime async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['synclocktime']);
    if (data[0]['value'] == null) return null;
    int intTime = int.parse(data[0]['value'].toString());
    return DateTime.fromMillisecondsSinceEpoch(intTime);
  }

  Future<void> setSyncLockTime(DateTime? time) async {
    await _database.update('preferences', {'value': time?.millisecondsSinceEpoch}, where: 'key = ?', whereArgs: ['synclocktime']);
  }

  Future<void> setLoggedTechnicianId(int id) async {
    await _database.update('preferences', {'value': id}, where: 'key = ?', whereArgs: ['loggedtechnicianid']);
  }

  Future<int> get loggedTechnicianId async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianid']);
    return int.parse(data[0]['value'].toString());
  }




  Future<void> setSyncCount(int id) async {
    await _database.update('preferences', {'value': id}, where: 'key = ?', whereArgs: ['synccount']);
  }

  Future<int> get syncCount async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['synccount']);
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
