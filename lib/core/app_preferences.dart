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

  Future<void> setLastSyncLock(DateTime? time) async {
    int? intTime = time?.millisecondsSinceEpoch;
    await _database.update('preferences', {'value': intTime}, where: 'key = ?', whereArgs: ['lastsynclock']);
  }

  Future<DateTime?> get lastSyncLock async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsynclock']);
    if (data[0]['value'] == null) return null;
    int intTime = int.parse(data[0]['value'].toString());
    return DateTime.fromMillisecondsSinceEpoch(intTime);
  }

  Future<void> setLastSyncCount(int count) async {
    await _database.update('preferences', {'value': count}, where: 'key = ?', whereArgs: ['lastsynccount']);
  }

  Future<int> get lastSyncCount async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsynccount']);
    return int.parse(data[0]['value'].toString());
  }

  Future<void> setLoggedTechnicianId(int id) async {
    await _database.update('preferences', {'value': id}, where: 'key = ?', whereArgs: ['loggedtechnicianid']);
  }

  Future<int> get loggedTechnicianId async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianid']);
    return int.parse(data[0]['value'].toString());
  }

  Future<String> get loggedTechnicianEmail async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianemail']);
    return data[0]['value'].toString();
  }

  Future<void> setLoggedTechnicianEmail(String email) async {
    await _database.update('preferences', {'value': email}, where: 'key = ?', whereArgs: ['loggedtechnicianemail']);
  }

  Future<String> get loggedTechnicianPassword async {
    var data = await _database.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['loggedtechnicianpassword']);
    return data[0]['value'].toString();
  }

  Future<void> setLoggedTechnicianPassword(String password) async {
    await _database.update('preferences', {'value': password}, where: 'key = ?', whereArgs: ['loggedtechnicianpassword']);
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
