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

  static const String insertLoggedTechnicianIdPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'loggedtechnicianid',
      '0'
    );
  ''';

  static const String insertIgnoreLastSynchronizePreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'ignorelastsynchronize',
      '0'
    );
  ''';


  static const String insertSyncLockTimePreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'synclocktime',
      NULL
    );
  ''';

  static const String insertSyncCountPreference = '''
    INSERT INTO preferences (
      key,
      value
    ) VALUES (
      'synccount',
      0
    );
  ''';

  static const String createTablePerson = '''
    CREATE TABLE person (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
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
      name TEXT NOT NULL,
      visible INTEGER NOT NULL,    
      lastupdate INTEGER NOT NULL
    );
  ''';

  static const String createTablePersonCompressor = '''
    CREATE TABLE personcompressor (
      id INTEGER PRIMARY KEY,
      personid INTEGER NOT NULL,
      visible INTEGER NOT NULL,
      compressorid INTEGER NOT NULL,
      serialnumber TEXT NOT NULL,
      patrimony TEXT NOT NULL,
      sector TEXT NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (personid) REFERENCES person (id) ON DELETE CASCADE,
      FOREIGN KEY (compressorid) REFERENCES compressor (id) ON DELETE RESTRICT
    );
  ''';

  static const String createTableProduct = '''
    CREATE TABLE product (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
      name TEXT NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';
  static const String createTableProductCode = '''
    CREATE TABLE productcode (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
      code TEXT NOT NULL,
      productid INT NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (productid) REFERENCES product (id) ON DELETE CASCADE
    );
  ''';
  static const String createTableService = '''
    CREATE TABLE service (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
      name TEXT NOT NULL,
      lastupdate INTEGER NOT NULL
    );
  ''';
  static const String createTablePersonCompressorCoalescent = '''
    CREATE TABLE personcompressorcoalescent (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
      personcompressorid INT NOT NULL,
      productid INT NOT NULL,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (personcompressorid) REFERENCES personcompressor (id) ON DELETE CASCADE,
      FOREIGN KEY (productid) REFERENCES product (id) ON DELETE RESTRICT
    );
  ''';

  static const String createTableEvaluation = '''
    CREATE TABLE evaluation (
      id TEXT PRIMARY KEY,
      visible INTEGER NOT NULL,
      importedid INTEGER,
      visitscheduleid INTEGER,
      existsincloud INTEGER NOT NULL,
      needproposal INTEGER NOT NULL,
      calltypeid INTEGER NOT NULL,
      unitname TEXT NOT NULL,
      temperature INTEGER NOT NULL,
      pressure REAL NOT NULL,
      customerid INT NOT NULL,
      compressorid INT NOT NULL,      
      creationdate INTEGER NOT NULL,
      starttime TEXT NOT NULL,
      endtime TEXT NOT NULL,
      horimeter INTEGER NOT NULL,
      oiltypeid INTEGER NOT NULL,
      airfilter INTEGER NOT NULL,
      oilfilter INTEGER NOT NULL,
      separator INTEGER NOT NULL,
      oil INTEGER NOT NULL,
      responsible TEXT NOT NULL,      
      signaturepath TEXT NOT NULL,
      advice TEXT,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (customerid) REFERENCES person (id) ON DELETE RESTRICT
      FOREIGN KEY (compressorid) REFERENCES personcompressor (id) ON DELETE RESTRICT
    );
  ''';

  static const String createTableEvaluationCoalescent = '''
    CREATE TABLE evaluationcoalescent (    
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      coalescentid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      nextchange INTEGER NOT NULL,
      FOREIGN KEY (coalescentid) REFERENCES personcompressorcoalescent (id) ON DELETE RESTRICT,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableEvaluationReplacedProduct = '''
    CREATE TABLE evaluationreplacedproduct (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quantity REAL NOT NULL,
      productid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      FOREIGN KEY (productid) REFERENCES product (id) ON DELETE RESTRICT,
      FOREIGN KEY (evaluationid) REFERENCES evaluation (id) ON DELETE CASCADE
    );
  ''';

  static const String createTableEvaluationPerformedService = '''
    CREATE TABLE evaluationperformedservice (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quantity REAL NOT NULL,
      serviceid INT NOT NULL,
      evaluationid TEXT NOT NULL,
      FOREIGN KEY (serviceid) REFERENCES service (id) ON DELETE RESTRICT,
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
    CREATE TABLE visitschedule (
      id INTEGER PRIMARY KEY,
      visible INTEGER NOT NULL,
      calltypeid INT NOT NULL,
      creationdate INTEGER NOT NULL,
      scheduleddate INTEGER NOT NULL,
      performeddate INTEGER,
      technicianid INTEGER NOT NULL,
      customerid INTEGER NOT NULL,
      compressorid INT NOT NULL,      
      instructions TEXT,
      lastupdate INTEGER NOT NULL,
      FOREIGN KEY (technicianid) REFERENCES person (id) ON DELETE RESTRICT,
      FOREIGN KEY (customerid) REFERENCES person (id) ON DELETE RESTRICT,
      FOREIGN KEY (compressorid) REFERENCES personcompressor (id) ON DELETE RESTRICT
    );
  ''';
}
