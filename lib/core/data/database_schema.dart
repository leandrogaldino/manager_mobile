import 'package:sqflite/sqflite.dart';
import 'package:manager_mobile/core/constants/sql_scripts.dart';

class DatabaseSchema {
  static Future<void> create(Database db) async {
    await db.execute(SQLScripts.createTablePreferences);
    await db.execute(SQLScripts.createTablePerson);
    await db.execute(SQLScripts.createTableCompressor);
    await db.execute(SQLScripts.createTableCompressorInterface);
    await db.execute(SQLScripts.createTableCompressorUnit);
    await db.execute(SQLScripts.createTablePersonCompressor);
    await db.execute(SQLScripts.createTableProduct);
    await db.execute(SQLScripts.createTableProductCode);
    await db.execute(SQLScripts.createTableService);
    await db.execute(SQLScripts.createTablePersonCompressorCoalescent);
    await db.execute(SQLScripts.createTableEvaluation);
    await db.execute(SQLScripts.createTableEvaluationReplacedProduct);
    await db.execute(SQLScripts.createTableEvaluationPerformedService);
    await db.execute(SQLScripts.createTableEvaluationTechnician);
    await db.execute(SQLScripts.createTableEvaluationCoalescent);
    await db.execute(SQLScripts.createTableEvaluationPhoto);
    await db.execute(SQLScripts.createTableVisitSchedule);
    await db.execute(SQLScripts.insertThemePreference);
    await db.execute(SQLScripts.insertLastSyncPreference);
    await db.execute(SQLScripts.insertLoggedTechnicianIdPreference);
    await db.execute(SQLScripts.insertIgnoreLastSynchronizePreference);
    await db.execute(SQLScripts.insertSyncLockTimePreference);
    await db.execute(SQLScripts.insertSyncCountPreference);
  }

  static Future<void> drop(Database db) async {
    await db.execute('DROP TABLE IF EXISTS evaluationphoto');
    await db.execute('DROP TABLE IF EXISTS evaluationcoalescent');
    await db.execute('DROP TABLE IF EXISTS evaluationtechnician');
    await db.execute('DROP TABLE IF EXISTS evaluationperformedservice');
    await db.execute('DROP TABLE IF EXISTS evaluationreplacedproduct');
    await db.execute('DROP TABLE IF EXISTS evaluation');
    await db.execute('DROP TABLE IF EXISTS visitschedule');
    await db.execute('DROP TABLE IF EXISTS personcompressorcoalescent');
    await db.execute('DROP TABLE IF EXISTS personcompressor');
    await db.execute('DROP TABLE IF EXISTS compressorunit');
    await db.execute('DROP TABLE IF EXISTS compressorinterface');
    await db.execute('DROP TABLE IF EXISTS compressor');
    await db.execute('DROP TABLE IF EXISTS productcode');
    await db.execute('DROP TABLE IF EXISTS product');
    await db.execute('DROP TABLE IF EXISTS service');
    await db.execute('DROP TABLE IF EXISTS person');
    final List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='preferences'");
    if (tables.isNotEmpty) {
      await db.execute("UPDATE preferences SET value = '0' WHERE key = 'synccount'");
      await db.execute("UPDATE preferences SET value = '0' WHERE key = 'lastsync'");
    }
  }
}
