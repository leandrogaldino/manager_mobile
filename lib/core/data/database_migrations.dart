import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    /*
    if (oldVersion < 2) {
      await _v2(db);
    }

    if (oldVersion < 3) {
      await _v3(db);
    }

    if (oldVersion < 4) {
      await _v4(db);
    }
    */
  }

  //static Future<void> _v2(Database db) async {}

  //static Future<void> _v3(Database db) async {}

  //static Future<void> _v4(Database db) async {}
}
