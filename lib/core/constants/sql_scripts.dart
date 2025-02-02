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
      '0'
    );
  ''';

  static const String insertSyncronizingPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'syncronizing',
      '0'
    );
  ''';

  static const String insertloggedTechnicianIdPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'loggedtechnicianid',
      '0'
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

  static const String createTableCompressor = '''
    CREATE TABLE compressor (
      id INTEGER PRIMARY KEY,
      personid INTEGER NOT NULL,
      statusid INTEGER NOT NULL,
      compressorid INTEGER NOT NULL,
      compressorname TEXT NOT NULL,
      serialnumber TEXT NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (personid) REFERENCES person (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableCoalescent = '''
    CREATE TABLE coalescent (
      id INTEGER PRIMARY KEY,
      statusid INTEGER NOT NULL,
      personcompressorid INT NOT NULL,
      coalescentname TEXT NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (personcompressorid) REFERENCES compressor (id) ON DELETE CASCADE
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
      importingdate INTEGER,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
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
      oiltypeid INTEGER NOT NULL,
      airfilter INTEGER NOT NULL,
      oilfilter INTEGER NOT NULL,
      oil INTEGER NOT NULL,
      separator INTEGER NOT NULL,
      responsible TEXT NOT NULL,
      advice TEXT,
      signaturepath TEXT NOT NULL,
      infoid INTEGER NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (infoid) REFERENCES evaluationinfo (id) ON DELETE CASCADE,
      FOREIGN KEY (compressorid) REFERENCES compressor (id) ON DELETE RESTRICT
    );
  ''';

  static const String createTableEvaluationCoalescent = '''
    CREATE TABLE evaluationcoalescent (    
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      coalescentid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      nextchange INTEGER NOT NULL,
      FOREIGN KEY (coalescentid) REFERENCES coalescent (id) ON DELETE RESTRICT,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableEvaluationTechnician = '''
    CREATE TABLE evaluationtechnician (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ismain INTEGER NOT NULL,
      personid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      FOREIGN KEY (personid) REFERENCES person (id) ON DELETE RESTRICT,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableEvaluationPhoto = '''
    CREATE TABLE evaluationphoto (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL,
      evaluationid TEXT NOT NULL,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableSchedule = '''
    CREATE TABLE schedule (
      id INTEGER PRIMARY KEY,
      compressorid INT NOT NULL,
      statusid INT NOT NULL,
      creationdate INTEGER NOT NULL,
      visitdate INTEGER NOT NULL,
      visittypeid INT NOT NULL,
      instructions TEXT,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (compressorid) REFERENCES compressor (id) ON DELETE RESTRICT
    );
  ''';
}
