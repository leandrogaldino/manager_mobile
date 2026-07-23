import 'package:manager_mobile/core/data/database_schema.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseMigrations {
  static Future<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _v2(db);
    }
  }

  static Future<void> _v2(Database db) async {
    await DatabaseSchema.drop(db);
    await DatabaseSchema.create(db);
  }
}
