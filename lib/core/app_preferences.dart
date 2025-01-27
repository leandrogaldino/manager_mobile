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
}
