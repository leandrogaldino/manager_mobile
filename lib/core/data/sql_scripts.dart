class SQLScripts {
  static const String createTablePreferences = '''
    CREATE TABLE preferences (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      key TEXT NOT NULL UNIQUE,
      value TEXT
    );
  ''';

  static const String insertThemePreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'theme',
      'ThemeMode.system'
    );
  ''';

  static const String insertLastSyncPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'lastsync',
      0
    );
  ''';

  static const String insertSyncronizingPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'syncronizing',
      0
    );
  ''';

  static const String createTableCoalescent = '''
    CREATE TABLE coalescent (
      id INTEGER PRIMARY KEY,
      statusid INTEGER NOT NULL,
      personcompressorid INT NOT NULL,
      coalescentname TEXT NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';

  static const String createTableCompressor = '''
    CREATE TABLE compressor (
      id INTEGER PRIMARY KEY,
      personid INTEGER NOT NULL,
      statusid INTEGER NOT NULL,
      compressorid INTEGER NOT NULL,
      compressorname TEXT NOT NULL,
      serialnumber TEXT NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';

  static const String createTablePerson = '''
    CREATE TABLE person (
      id INTEGER PRIMARY KEY,
      statusid INTEGER NOT NULL,
      document TEXT NOT NULL,
      shortname TEXT NOT NULL,
      iscustomer INTEGER NOT NULL,
      istechnician INTEGER NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';

  static const String createTableEvaluation = '''
    CREATE TABLE evaluation (
      id TEXT PRIMARY KEY,
      compressorid INT NOT NULL,
      creationdate INTEGER NOT NULL,
      starttime TEXT NOT NULL,
      endtime TEXT NOT NULL,
      horimeter INTEGER NOT NULL,
      airfilter INTEGER NOT NULL,
      oilfilter INTEGER NOT NULL,
      oil INTEGER NOT NULL,
      separator INTEGER NOT NULL,
      responsible TEXT NOT NULL,
      advice TEXT,
      signaturepath TEXT NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';

  static const String createTableEvaluationCoalescent = '''
    CREATE TABLE evaluationcoalescent (    
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      coalescentid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      nextchange INTEGER NOT NULL
    );
  ''';

  static const String createTableEvaluationTechnician = '''
    CREATE TABLE evaluationtechnician (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      personid INT NOT NULL,
      evaluationid TEXT NOT NULL
    );
  ''';

  static const String createTableEvaluationPhoto = '''
    CREATE TABLE evaluationphoto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL,
      evaluationid TEXT NOT NULL
    );
  ''';

  static const String createTableEvaluationInfo = '''
    CREATE TABLE evaluationinfo (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      evaluationid TEXT NOT NULL,
      imported INTEGER NOT NULL,
      importedby TEXT,
      importeddate INTEGER,
      importedid INTEGER,
      importingby TEXT,
      importingdate INTEGER
    );
  ''';

  static const String createTableSchedule = '''
    CREATE TABLE schedule (
      id INTEGER PRIMARY KEY,
      creation INTEGER NOT NULL,
      customerid INT NOT NULL,
      evaluationid INT DEFAULT NULL,
      instructions TEXT,
      lastupdate INTEGER NOT NULL,
      personcompressorid INT NOT NULL,
      statusid INT NOT NULL,
      visitdate INTEGER NOT NULL,
      visittypeid INT NOT NULL
    );
  ''';
}
